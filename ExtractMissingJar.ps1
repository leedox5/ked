param (
    [string]$SourceRoot = "\\CIAST\KoDATA",
    [string]$TargetRoot = "D:\WORK\DATA"
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

# Source 날짜폴더 목록 수집
$sourceDates = Get-ChildItem -Path $SourceRoot -Directory |
    Where-Object {
        $_.Name -match '^\d{8}$'
    } |
    Select-Object -ExpandProperty Name

# Target 날짜폴더 목록 수집
$targetDates = Get-ChildItem -Path $TargetRoot -Directory -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Name -match '^\d{8}$'
    } |
    Select-Object -ExpandProperty Name

$missingDates = $sourceDates | Where-Object { $_ -notin $targetDates }

if (-not $missingDates) {
    Log "No missing dates found. Everything is up to date." "INFO"
    return
}

$nextFive = $missingDates | 
    Sort-Object { [int]$_ } | 
    Select-Object -First 5

Log "Next 5 dates to process (oldest first): $($nextFive -join ', ')" "INFO"
Log ""

foreach ($dateStr in $nextFive) {
    Invoke-ExtractJarForDate -DateStr $dateStr -TargetRoot $TargetRoot
}


