<#
while ($true) {
    Add-Content "D:\WORK\LOGS\TEST1.LOG" "$(Get-Date)"
    Start-Sleep 10
}
#>
$LogDir = "D:\WORK\LOGS"
$LogFile = Join-Path $LogDir ("LoadDB1215_{0}.log" -f (Get-Date -Format "yyyyMMdd"))
& "D:\Projects\ked\LoadDB1215.ps1" *>> $LogFile
