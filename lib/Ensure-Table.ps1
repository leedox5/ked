function Ensure-Table {
    param(
        [pscustomobject]$Config,
        [string]$TableName,
        [string]$DdlRoot
    )

    $db = $Config.MySQL.Database

    $existsSql = @"
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = '$db'
  AND table_name   = '$TableName';
"@

    $cnt = Invoke-MySqlScalar -Config $Config -Sql $existsSql

    if ($cnt -eq "0") {
        $ddlPath = Join-Path $DdlRoot "$TableName.sql"

        Log "Table not found -> CREATE: $TableName ($ddlPath)" "WARN"

        if (-not (Test-Path -LiteralPath $ddlPath)) {
            throw "DDL file not found for table: $TableName ($ddlPath)"
        }

        $ddl = Get-Content -LiteralPath $ddlPath -Raw -Encoding UTF8

        Invoke-MySql -Config $Config -Sql $ddl

        Log "Table created: $TableName"
    }
    else {
        Log "Table exists: $TableName"
    }
}
