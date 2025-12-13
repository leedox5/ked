param (
    [string]$ConfigPath = "D:\WORK\config.json"
)

function Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Get-AppConfig {
    param(
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Config file not found: $Path"
    }

    $json = Get-Content $Path -Raw
    $config = $json | ConvertFrom-Json

    return $config
}

function Invoke-MySql {
    param(
        [pscustomobject]$Config,    
        [string]$Sql
    )
    $user = $Config.MySQL.User
    $pass = $Config.MySQL.Password
    $db = $Config.MySQL.Database

    $arguments = @(
        "--local-infile=1"
        "-u", $user
        "-p$pass"
        $db
        "-e", $sql
    )
    
    Log "Executing: $sql"

    & mysql $arguments

    if ($LASTEXITCODE -ne 0) {
        throw "mysql.exe faild. exitCode=$LASTEXITCODE"
    }
}


try {
    $config = Get-AppConfig -Path $ConfigPath
    
    $TargetRoot = $config.TargetRoot
    $TargetTables = $config.TargetTables
    $maxCount = $config.MaxLoadCount

    $skipCount = 0
    $doneCount = 0

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

            $doneFile = [IO.path]::ChangeExtension($utf.FullName, ".done")

            if ($doneCount -ge $maxCount) {
                Log "MAX LOAD COUNT REACHED -> STOP BATCH"
                Log "SKIP: $skipCount, DONE: $doneCount"
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
                if ($table -eq "KED5026") {
                    $procName += "_HIST"
                }

                Invoke-MySql -Config $config -sql "CALL $procName('$stdDate');"

                New-Item -ItemType File -Path $doneFile | Out-Null
                Log "DONE CREATED --> $doneFile"

                $doneCount++
            }
            catch {
                Log "ERROR on $table / $stdDate : $($_.Exception.Message)" "ERROR"
            }
        }
    }       
    Log "SKIP: $skipCount, DONE: $doneCount"
}
catch {
    Log $_.Exception.Message "ERROR"
    exit 1
}

