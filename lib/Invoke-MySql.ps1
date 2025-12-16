function Invoke-MySql {
    param(
        [pscustomobject]$Config,    
        [string]$Sql
    )
    $user = $Config.MySQL.User
    $pass = $Config.MySQL.Password
    $db = $Config.MySQL.Database

    $arguments = @(
        "--login-path=ked"
        "--default-character-set=utf8mb4"
        "--local-infile=1"
        $db
        "-e", $sql
    )
    
    Log "Executing: $sql"

    & mysql $arguments

    if ($LASTEXITCODE -ne 0) {
        throw "mysql.exe faild. exitCode=$LASTEXITCODE"
    }
}
