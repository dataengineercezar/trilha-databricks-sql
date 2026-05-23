param(
    [string]$Profile = "cezar_databricks",
    [string]$WarehouseId = "",
    [string]$Catalog = "workspace",
    [string]$Schema = "databricks_sql_track"
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path "$PSScriptRoot\.."
$runner = Join-Path $root "scripts\run_sql_file_databricks.ps1"

$files = @(
    "datasets\seed_ecommerce.sql",
    "exercicios\semana01_sql_warehouse_setup\labs\01_workspace_sql.sql",
    "exercicios\semana02_delta_sql_modelagem\labs\02_delta_modelagem.sql"
)

foreach ($relativePath in $files) {
    $path = Join-Path $root $relativePath

    $args = @{
        SqlFile = $path
        Profile = $Profile
        Catalog = $Catalog
        Schema = $Schema
    }

    if ($WarehouseId) {
        $args.WarehouseId = $WarehouseId
    }

    & $runner @args
}

Write-Host "Free validation completed."
