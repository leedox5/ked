param (
    [ValidateSet("Service", "Test")]
    [string]$Mode = "Service"
)

$LogDir  = "D:\WORK\LOGS"

if (-not (Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

$LogFile1 = Join-Path $LogDir ("ExtractMissingJar_{0}.log" -f (Get-Date -Format "yyyyMMdd"))
$LogFile2 = Join-Path $LogDir ("KED_ConvertUTF8_{0}.log" -f (Get-Date -Format "yyyyMMdd"))
$LogFile3 = Join-Path $LogDir ("LoadDB1215_{0}.log" -f (Get-Date -Format "yyyyMMdd"))
$LogFile4 = Join-Path $LogDir ("LoadDATA_{0}.log" -f (Get-Date -Format "yyyyMMdd"))

function Write-Log {
    param([string]$Message)

    $logFile = Join-Path $LogDir ("scheduler_{0}.log" -f (Get-Date -Format "yyyyMMdd"))
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Add-Content -Path $logFile -Value $line -Encoding UTF8
}

function Invoke-Job {
    Write-Log ">>>> Job started."

    # 실제 실행할 스크립트
    Write-Log "0001 Processing ExtractMissingJar.ps1"
    & "D:\Projects\ked\ExtractMissingJar.ps1" *>> $LogFile1

    Write-Log "0002 Processing KED_ConvertUTF8.ps1"
    & "D:\Projects\ked\KED_ConvertUTF8.ps1" *>> $LogFile2

    Write-Log "0003 Processing LoadDB1215.ps1"
    & "D:\Projects\ked\LoadDB1215.ps1" *>> $LogFile3
    
    Write-Log "0004 Processing LoadDATA.ps1"
    & "D:\Projects\ked\LoadDATA.ps1" *>> $LogFile4

    Write-Log ">>>> Job finished."
}

try {
    Write-Log "==== Scheduler started. Mode=$Mode"

    if ($Mode -eq "Test") {
        Invoke-Job
        Write-Log "==== Test mode finished."
        exit 0
    }

    $LastRunSlot = ""

    while ($true) {
        $now = Get-Date
        $CurrentSlot = $now.ToString("yyyyMMddHH")
        # 예: 07:00 실행
        # if ($now.Hour -eq 7 -and $now.Minute -eq 0) {
        # 60분마다
        if ($now.Minute -eq 0 -and $CurrentSlot -ne $LastRunSlot) {
            $LastRunSlot = $CurrentSlot
            Invoke-Job
        }
        Start-Sleep -Seconds 30
    }
}
catch {
    Write-Log "ERROR: $($_.Exception.Message)"
    exit 1
}

<#
while ($true) {
    try {
        $now = Get-Date

        # 예: 07:00 실행
        # if ($now.Hour -eq 7 -and $now.Minute -eq 0) {
        # 30분마다
        if ($now.Minute % 2 -eq 0) {
            Write-Log ">>>> Job started."

            # 실제 실행할 스크립트
            Write-Log "0001 Processing ExtractMissingJar.ps1"
            & "D:\Projects\ked\ExtractMissingJar.ps1" *>> $LogFile1

            Write-Log "0002 Processing KED_ConvertUTF8.ps1"
            & "D:\Projects\ked\KED_ConvertUTF8.ps1" *>> $LogFile2

            Write-Log "0003 Processing LoadDB1215.ps1"
            & "D:\Projects\ked\LoadDB1215.ps1" *>> $LogFile3
            
            Write-Log "0004 Processing LoadDATA.ps1"
            & "D:\Projects\ked\LoadDATA.ps1" *>> $LogFile4

            Write-Log ">>>> Job finished."

            # 같은 1분 안에 중복 실행 방지
            Start-Sleep -Seconds 70
        }

        Start-Sleep -Seconds 10
    }
    catch {
        Write-Log "ERROR: $($_.Exception.Message)"
        Start-Sleep -Seconds 30
    }
}
#>
