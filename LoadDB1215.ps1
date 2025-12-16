$ConfigPath = "D:\WORK\config-db1215.json";

$lib = Join-Path $PSScriptRoot "lib"

. "$lib\Get-AppConfig.ps1"
. "$lib\Log.ps1"
. "$lib\Invoke-MySql.ps1"
. "$lib\Invoke-MySqlScalar.ps1"
. "$lib\Ensure-Table.ps1"
. "$lib\Ensure-Procedure.ps1"

$config = Get-AppConfig -Path $ConfigPath

$TargetRoot = $config.TargetRoot
$TargetTables = $config.TargetTables
$maxCount = $config.MaxLoadCount

$skipCount = 0
$doneCount = 0
$errorCount = 0

$TargetTables = ($config.TargetTables -split '\s*,\s*') | Where-Object { $_ -ne '' }


$DdlRoot = $config.DdlRoot

if (-not $DdlRoot) {
    throw "DdlRoot is missing in config.json"
}

foreach ($t in $TargetTables) {
    Ensure-Table -Config $config -TableName $t -DdlRoot $DdlRoot
    Ensure-Table -Config $config -Tablename "$($t)_H" -DdlRoot $DdlRoot

    $procName = "CHK_$t"
    Ensure-Procedure -Config $config -ProcName $procName -DdlRoot $DdlRoot
}

$folders = Get-ChildItem $TargetRoot -Directory |
Sort-Object Name -Descending

foreach ($d in $folders) {
    $dir = Join-Path $TargetRoot $d
    $utfFiles = Get-ChildItem -Path $dir -Filter "*UTF8.txt" -ErrorAction SilentlyContinue

    Log "Working Folder $dir"

    foreach ($utf in $utfFiles) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($utf.Name)
        $parts = $baseName.Split('-');
        $table = $parts[0]
        $stdDate = $parts[1]

        $doneFile = [IO.path]::ChangeExtension($utf.FullName, ".comp")

        if ($doneCount -ge $maxCount) {
            Log "MAX LOAD COUNT REACHED -> STOP BATCH"
            Log "SKIP: $skipCount, DONE: $doneCount"
            return
        }

        if ($errorCount -ge $maxCount) {
            Log "MAX Error count reached, STOP BATCH"
            Log "SKIP: $skipCount, DONE: $doneCount, ERROR: $errorCount"
            return
        }

        if (Test-Path $doneFile) {
            $skipCount++
            continue
        }

        if (-not $TargetTables.Contains($table)) {
            $skipCount++
            continue
        }

        try {
            Invoke-MySql -Config $config -sql "TRUNCATE TABLE $table;"

            # MySQL-safe path
            $mysqlFilePath = $utf.FullName -replace "\\", "/"  

            Invoke-MySql -Config $config -sql "LOAD DATA LOCAL INFILE '$mysqlFilePath' INTO TABLE $table FIELDS TERMINATED BY '|';"

            $procName = "CHK_$table"
            
            <#
            if ($table -eq "KED5026") {
                $procName += "_HIST"
            }
            #>

            Invoke-MySql -Config $config -sql "CALL $procName('$stdDate');"

            New-Item -ItemType File -Path $doneFile | Out-Null
            Log "DONE CREATED --> $doneFile"

            $doneCount++
        }
        catch {
            Log "ERROR on $table / $stdDate : $($_.Exception.Message)" "ERROR"
            $errorCount++
        }
    }
}       
Log "SKIP: $skipCount, DONE: $doneCount"
