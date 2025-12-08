param (
    [string]$startDate
)

# User configuration
$targetRoot = "D:\WORK\DATA"
$chkFile = "CHK-2505-02.LOG"
$mysqlUser = "root"
$mysqlPass = "12345678"
$mysqlDB   = "db0430"

# Console log function
function Log {
    param([string]$msg)
    Write-Host $msg
}

# 📌 Save current location
$originalLocation = Get-Location

$truncateCmd = "mysql --local-infile=1 -u $mysqlUser -p$mysqlPass $mysqlDB -e `"TRUNCATE TABLE ked5026;`""
Invoke-Expression $truncateCmd
Log "TABLE 'ked5026' truncated before loading"

$dt = Get-Date

if (-not $startDate) {
    $dateStr = $dt.ToString("yyyyMMdd")
} else {
    $dateStr = $startDate
}

$logDir = "D:\WORK\LOGS"
$logPath = Join-Path $logDir "KED5026-$dateStr.LOG"

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}

Start-Transcript -Path $logPath -Append

$jarRealPath = "\\CIAST\KoDATA\$dateStr\ciast_$dateStr.jar"
$targetDir = Join-Path $targetRoot $dateStr

$sourceFile = Join-Path $targetDir "KED5026.txt"
$utf8File = "$targetDir\KED5026-$dateStr-UTF8.txt"

Log "STEP1 : Processing for current date: $dateStr"
Log "------------------------------------------------"
if (-not (Test-Path $jarRealPath)) {
    Log "WARNING: JAR file not found: $jarRealPath"
} else {
    # Prepare working directory
    if (-not (Test-Path $targetDir)) {
        New-Item -Path $targetDir -ItemType Directory | Out-Null
    }

    if (Test-Path $sourceFile) {
        Log "SKIP --> $sourceFile"
    } else {
        Set-Location $targetDir
        jar -xvf $jarRealPath | Out-Null
    }

    if (Test-Path $utf8File) {
        Log "SKIP --> $utf8File"
    } else {
        (Get-Content -Path $sourceFile) | Set-Content -Encoding UTF8 -Path $utf8File
        Log "UTF-8 conversion complete: $utf8File"
    }
}

$folders = Get-ChildItem $targetRoot -Directory |
    Sort-Object Name |
    Where-Object {
        -Not (Test-Path (Join-Path $_.FullName $chkFile))
    } |
    Select-Object -First 5

foreach ($folder in $folders) {
    $ds = $folder.Name
    $utf8File = Join-Path $folder.FullName "KED5026-$ds-UTF8.txt"
    $mysqlFilePath = $utf8File -replace "\\", "/"  # MySQL-safe path

    if (Test-Path $utf8File) {
        Log "Processing $utf8File"
        # Load to MySQL
        $mysqlCmd = "mysql --local-infile=1 -u $mysqlUser -p$mysqlPass $mysqlDB -e `"LOAD DATA LOCAL INFILE '$mysqlFilePath' INTO TABLE ked5026 FIELDS TERMINATED BY '|';`""
        Invoke-Expression $mysqlCmd
        Log "MySQL load complete for $utf8File"

        $procCmd = "mysql --local-infile=1 -u $mysqlUser -p$mysqlPass $mysqlDB -e `"CALL CHK_KED5026_HIST('$ds');`""
        Invoke-Expression $procCmd
        Log "CHK_KED5026_HIST('$ds') executed"
    } else {
        Log "WARNING: Source file not found: $utf8File"
    }
    $logPath = Join-Path $folder.FullName $chkFile
    "DONE" | Out-File -FilePath $logPath -Encoding UTF8
    Log "> Created $chkFile in folder: $($folder.Name)"
    Log "------------------------------------------------"
}

if ($folders.Count -eq 0) {
    Log "> No eligible folders found. All $chkFile files may already exist."
}

# ✅ After all processing
Set-Location $originalLocation

Stop-Transcript

