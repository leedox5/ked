function Invoke-MySqlScalar {
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
        "-N", "-B"              # 결과만 깔끔하게
        $db
        "-e", $Sql
    )

    $out = & mysql @arguments

    if ($LASTEXITCODE -ne 0) {
        throw "mysql.exe failed. exitCode=$LASTEXITCODE, output=$out"
    }


    $first = ($out | Select-Object -First 1 | ForEach-Object { $_.ToString() })
    return $first.Trim()
}
