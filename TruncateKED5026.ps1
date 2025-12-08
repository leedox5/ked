param (
    [string]$StartDate,
    [string]$ConfigPath = ".\config.json"
)

# Console log function
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
        [pscustomobject]$Config
    )

    $mysqlUser = $Config.MySQL.User
    $mysqlPass = $Config.MySQL.Password
    $mysqlDB   = $Config.MySQL.Database
    $tableName = $Config.MySQL.Table

    $arguments = @(
        "--local-infile=1"
        "-u", $mysqlUser
        "-p$mysqlPass"
        $mysqlDB
        "-e", "TRUNCATE TABLE $tableName;"
    )
    
    & mysql @arguments
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0) {
        Log "TABLE '$tableName' truncated successfully" "INFO"
        throw "Failed to truncate table '$tableName'. MySQL exited with code $exitCode."
    }
    else {
        Log "Failed to truncate table '$tableName'. ExitCode=$exitCode" "ERROR"
        throw "MySQL command failed with exit code $exitCode"
    }
}

try {
    $config = Get-AppConfig -Path $ConfigPath
    Invoke-TableTruncate -Config $config
}
catch {
    Log $_.Exception.Message "ERROR"
    exit 1
}

