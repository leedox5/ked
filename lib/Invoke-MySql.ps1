function Invoke-MySql {
    param(
        [pscustomobject]$Config,    
        [string]$Sql
    )
    $db = $Config.MySQL.Database
    $LoginPath = $Config.MySQL.LoginPath

    $arguments = @(
        "--login-path=$LoginPath"
        "--default-character-set=utf8mb4"
        "--local-infile=1"
        $db
        "-e", $sql
    )
    <#
    Log "Executing: $sql"
    #>

    & mysql $arguments

    if ($LASTEXITCODE -ne 0) {
        throw "mysql.exe faild. exitCode=$LASTEXITCODE"
    }
}
