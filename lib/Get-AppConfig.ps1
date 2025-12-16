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
