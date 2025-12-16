function Ensure-Procedure {
    param(
        [pscustomobject]$Config,
        [string]$ProcName,
        [string]$DdlRoot
    )

    $db = $Config.MySQL.Database

    $existsSql = @"
SELECT COUNT(*)
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = '$db'
  AND ROUTINE_NAME   = '$ProcName'
  AND ROUTINE_TYPE   = 'PROCEDURE';
"@

    $cnt = Invoke-MySqlScalar -Config $Config -Sql $existsSql

    if ($cnt -eq "0") {
        $ddlPath = Join-Path $DdlRoot "$ProcName.sql"

        Log "Procedure not found -> CREATE: $ProcName ($ddlPath)" "WARN"

        if (-not (Test-Path -LiteralPath $ddlPath)) {
            throw "Procedure DDL file not found: $ddlPath"
        }

        $ddl = Get-Content -LiteralPath $ddlPath -Raw -Encoding UTF8
        Invoke-MySql -Config $Config -Sql $ddl

        Log "Procedure created: $ProcName"
    }
    else {
        Log "Procedure exists: $ProcName"
    }
}
