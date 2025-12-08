param (
    [string]$StartDate = (Get-Date).AddDays(-1).ToString("yyyyMMdd"),
    [string]$EndDate = (Get-Date).ToString("yyyyMMdd")
)

function Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Invoke-ExtractJarForDate {
    param(
        [string]$DateStr,
        [string]$TargetRoot = "D:\WORK\DATA"
    )

    $jarRealPath = "\\CIAST\KoDATA\$DateStr\ciast_$DateStr.jar"
    $targetDir = Join-Path $TargetRoot $DateStr

    $sourceFile = Join-Path $targetDir "KED5026.txt"
    $utf8File = "$targetDir\KED5026-$DateStr-UTF8.txt"

    Log "Processing for current date: $DateStr"
 
    if (-not (Test-Path $jarRealPath)) {
        Log "WARNING: JAR file not found: $jarRealPath" "WARN"
        return
    } 

    # Prepare working directory
    if (-not (Test-Path $targetDir)) {
        Log "Creating target directory: $targetDir" "INFO"
        New-Item -Path $targetDir -ItemType Directory | Out-Null
    }

    if (Test-Path $sourceFile) {
        Log "SKIP (already exists) --> $sourceFile"
    } 
    else {
        Log "Extracting JAR file to $targetDir" "INFO"
        Push-Location $targetDir
        try {
            jar -xvf $jarRealPath | Out-Null
        }
        finally {
            Pop-Location
        }
    }

    if (Test-Path $utf8File) {
        Log "SKIP (already exists) --> $utf8File"
    }
    else {
        if (-not (Test-Path $sourceFile)) {
            Log "ERROR: Source file not found for UTF-8 conversion: $sourceFile" "ERROR"
            return
        }

        (Get-Content -Path $sourceFile) | 
            Set-Content -Encoding UTF8 -Path $utf8File

        Log "UTF-8 conversion complete: $utf8File"
    }

    Log "DOME : $DateStr"
    Log ""
}

$start = [datetime]::ParseExact($StartDate, "yyyyMMdd", $null)
$end = [datetime]::ParseExact($EndDate, "yyyyMMdd", $null)

if ($start -gt $end) {
    Log "ERROR: StartDate must be less than or equal to EndDate." "ERROR"
    exit 1
}

Log "DATE RANGE: $($start.ToString("yyyyMMdd")) to $($end.ToString("yyyyMMdd"))" "INFO"
Log ""

for ($dt = $start; $dt -le $end; $dt = $dt.AddDays(1)) {
    $dateStr = $dt.ToString("yyyyMMdd")
    Invoke-ExtractJarForDate -DateStr $dateStr
}