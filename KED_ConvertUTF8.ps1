param(
    [string]$ConfigPath = ".\config.json",
    [int]$MaxCount = 5   # 처리할 날짜 갯수
)

# ---------------------------------------------------------
# Load JSON Configuration
# ---------------------------------------------------------
function Get-AppConfig {
    param([string]$ConfigPath)

    if (Test-Path $ConfigPath) {
        return (Get-Content $ConfigPath -Raw | ConvertFrom-Json)
    }
    else {
        throw "Configuration file not found: $ConfigPath"
    }
}

$config = Get-AppConfig -ConfigPath $ConfigPath

$SourceRoot = $config.SourceRoot
$TargetRoot = $config.TargetRoot


# ---------------------------------------------------------
# Logging Utility
# ---------------------------------------------------------
function Log {
    param([string]$Message, [string]$Level = "INFO")
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$ts][$Level] $Message"
}


# ---------------------------------------------------------
# Convert TXT → UTF8 for a single date
# ---------------------------------------------------------
function Convert-UTF8ForDate {
    param([string]$DateStr)

    $targetDir = Join-Path $TargetRoot $DateStr

    if (-not (Test-Path $targetDir)) {
        Log "SKIP (folder missing) --> $DateStr" "WARN"
        return
    }

    Log "------------------------------------------------"
    Log "UTF8 CONVERT DATE --> $DateStr"

    # txt 파일 목록
    $txtFiles = Get-ChildItem -Path $targetDir -Filter "*.txt" |
            Where-Object { $_.Name -notmatch '-UTF8\.txt$' }

    foreach ($file in $txtFiles) {

        # 1) 0바이트 → Skip
        if ($file.Length -eq 0) {
            Log "SKIP EMPTY FILE --> $($file.Name)"
            continue
        }

        $base = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

        # 2) baseName-*-UTF8.txt 존재 여부 체크 → 있으면 Skip
        $utfExists = Get-ChildItem -Path $targetDir -Filter "$($base)-*-UTF8.txt" `
                     -ErrorAction SilentlyContinue

        if ($utfExists) {
            Log "SKIP (UTF8 exists) --> $base"
            continue
        }

        # 3) 변환 파일명 생성
        $dst = Join-Path $targetDir "$($base)-$DateStr-UTF8.txt"

        # 4) 변환 수행
        Log "CONVERT --> $dst"
        (Get-Content $file.FullName) |
            Set-Content -Encoding UTF8 -Path $dst
    }

    Log "UTF8 DONE --> $DateStr"
}


# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------

# 날짜 폴더 목록
$dateList = Get-ChildItem -Path $TargetRoot -Directory |
    Where-Object { $_.Name -match '^\d{8}$' } |
    Select-Object -ExpandProperty Name |
    Sort-Object {[int]$_}

# 가장 오래된 날짜부터 MaxCount개만 처리
$selectedDates = $dateList | Select-Object -First $MaxCount

Log "DATES TO CONVERT ($MaxCount) --> $($selectedDates -join ', ')"

foreach ($d in $selectedDates) {
    Convert-UTF8ForDate -DateStr $d
}

Log "ALL UTF8 CONVERT COMPLETE"
