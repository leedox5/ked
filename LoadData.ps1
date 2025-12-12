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

function Invoke-TableTruncate {
    param(
        [pscustomobject]$Config,
        [string]$TableName
    )

    $mysqlUser = $Config.MySQL.User
    $mysqlPass = $Config.MySQL.Password
    $mysqlDB = $Config.MySQL.Database

    $arguments = @(
        "--local-infile=1"
        "-u", $mysqlUser
        "-p$mysqlPass"
        $mysqlDB
        "-e", "TRUNCATE TABLE $TableName;"
    )
    
    & mysql @arguments
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Log "TABLE '$TableName' truncated successfully" "INFO"
    }
    else {
        Log "Failed to truncate table '$TableName'. ExitCode=$exitCode" "ERROR"
        throw "MySQL command failed with exit code $exitCode"
    }
}

function Invoke-LoadFromCsv {
    param (
        [PSCustomObject]$Config,
        [string]$Utf8File
    )
    $tableName = $Utf8File.Substring(22, 7)

    $mysqlUser = $Config.MySQL.User
    $mysqlPass = $Config.MySQL.Password
    $mysqlDB = $Config.MySQL.Database

    # MySQL-safe path
    $mysqlFilePath = $Utf8File -replace "\\", "/"  

    $arguments = @(
        "--local-infile=1"
        "-u", $mysqlUser 
        "-p$mysqlPass" 
        $mysqlDB 
        "-e" 
        "LOAD DATA LOCAL INFILE '$mysqlFilePath' INTO TABLE $tableName FIELDS TERMINATED BY '|';"
    )

    & mysql @arguments
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Log "TABLE ked5026 loaded successfully"
    }
    else {
        Log "Failed to load table ked5026. ExitCode=$exitCode" "ERROR"
        throw "MySQL command failed with exit code $exitCode"
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
                Invoke-TableTruncate -Config $config -TableName $table
                Invoke-LoadFromCsv -Config $config -Utf8File $utf.FullName

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

