function Invoke-MySql {
    param(
        [pscustomobject]$Config,    
        [string]$Sql
    )
    $user = $Config.MySQL.User
    $pass = $Config.MySQL.Password
    $db = $Config.MySQL.Database

    $arguments = @(
        "--default-character-set=utf8mb4"
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
