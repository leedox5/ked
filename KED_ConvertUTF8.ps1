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
#   1) TargetRoot 아래 yyyyMMdd 폴더 전체 스캔
#   2) 각 날짜 폴더에 대해 "아직 변환할 txt가 남아있는지" 체크
#   3) 작업 필요 날짜만 모아서, 가장 오래된 것부터 MaxCount개 선택
# ---------------------------------------------------------


# 1) 모든 날짜 폴더 후보
$allDates = Get-ChildItem -Path $TargetRoot -Directory |
    Where-Object { $_.Name -match '^\d{8}$' } |
    Select-Object -ExpandProperty Name

$pendingDates = @()

foreach ($d in $allDates) {
    $dir = Join-Path $TargetRoot $d

    # 폴더 내 원본 txt 후보:
    #  - *.txt
    #  - 이름에 -UTF8.txt가 없는 것
    #  - 0바이트 아님
    $candidates = Get-ChildItem -Path $dir -Filter "*.txt" -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -notmatch '-UTF8\.txt$' -and $_.Length -gt 0 }

    if ($candidates -and $candidates.Count -gt 0) {
        # 아직 변환할 txt가 남아있는 날짜
        $pendingDates += $d
    }
}

if (-not $pendingDates) {
    Log "NO PENDING DATES: All TXT files are already UTF8-converted."
    exit
}

# 2) 작업 필요 날짜를 정렬 후, 가장 오래된 것부터 MaxCount개 선택
$selectedDates = $pendingDates |
    Sort-Object { [int]$_ } |
    Select-Object -First $MaxCount

Log "PENDING DATES TO CONVERT (up to $MaxCount) --> $($selectedDates -join ', ')"
Log ""

foreach ($d in $selectedDates) {
    Convert-UTF8ForDate -DateStr $d
}

Log "ALL UTF8 CONVERT PASS COMPLETE"
