param(
    [Parameter(Mandatory = $true)]
    [string]$SqlFile,

    [string]$Profile = "cezar_databricks",
    [string]$WarehouseId = "",
    [string]$Catalog = "workspace",
    [string]$Schema = "databricks_sql_track",
    [int]$WaitTimeoutSeconds = 50
)

$ErrorActionPreference = "Stop"

function Get-DefaultWarehouseId {
    param([string]$Profile)

    $warehousesJson = databricks warehouses list -p $Profile --output json
    $warehouses = $warehousesJson | ConvertFrom-Json

    if (-not $warehouses -or $warehouses.Count -eq 0) {
        throw "No SQL Warehouse found for profile '$Profile'."
    }

    $serverless = $warehouses | Where-Object { $_.enable_serverless_compute -eq $true } | Select-Object -First 1
    if ($serverless) {
        return $serverless.id
    }

    return ($warehouses | Select-Object -First 1).id
}

function Split-SqlStatements {
    param([string]$SqlText)

    $statements = New-Object System.Collections.Generic.List[string]
    $buffer = New-Object System.Text.StringBuilder
    $inSingleQuote = $false
    $inDoubleQuote = $false

    for ($i = 0; $i -lt $SqlText.Length; $i++) {
        $ch = $SqlText[$i]

        if ($ch -eq "'" -and -not $inDoubleQuote) {
            $inSingleQuote = -not $inSingleQuote
            [void]$buffer.Append($ch)
            continue
        }

        if ($ch -eq '"' -and -not $inSingleQuote) {
            $inDoubleQuote = -not $inDoubleQuote
            [void]$buffer.Append($ch)
            continue
        }

        if ($ch -eq ';' -and -not $inSingleQuote -and -not $inDoubleQuote) {
            $statement = $buffer.ToString().Trim()
            if ($statement.Length -gt 0 -and (Test-SqlHasExecutableContent -Statement $statement)) {
                $statements.Add($statement)
            }
            [void]$buffer.Clear()
            continue
        }

        [void]$buffer.Append($ch)
    }

    $last = $buffer.ToString().Trim()
    if ($last.Length -gt 0 -and (Test-SqlHasExecutableContent -Statement $last)) {
        $statements.Add($last)
    }

    return $statements
}

function Test-SqlHasExecutableContent {
    param([string]$Statement)

    $withoutLineComments = ($Statement -split "`r?`n" | Where-Object {
        $_.TrimStart().StartsWith("--") -eq $false
    }) -join "`n"

    return $withoutLineComments.Trim().Length -gt 0
}

function Write-Utf8NoBom {
    param(
        [string]$Path,
        [string]$Content
    )

    $encoding = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $encoding)
}

function Invoke-DatabricksSql {
    param(
        [string]$Statement,
        [string]$Profile,
        [string]$WarehouseId,
        [string]$Catalog,
        [string]$Schema,
        [int]$WaitTimeoutSeconds
    )

    $payload = @{
        warehouse_id = $WarehouseId
        statement = $Statement
        wait_timeout = "$($WaitTimeoutSeconds)s"
        on_wait_timeout = "CONTINUE"
        catalog = $Catalog
        schema = $Schema
    } | ConvertTo-Json -Compress

    $tmp = Join-Path $env:TEMP ("databricks-sql-" + [Guid]::NewGuid().ToString() + ".json")
    Write-Utf8NoBom -Path $tmp -Content $payload

    try {
        $responseJson = databricks api post /api/2.0/sql/statements -p $Profile --json "@$tmp" --output json
        $response = $responseJson | ConvertFrom-Json
    }
    finally {
        if (Test-Path $tmp) {
            Remove-Item -LiteralPath $tmp -Force
        }
    }

    $statementId = $response.statement_id
    $state = $response.status.state

    while ($state -in @("PENDING", "RUNNING")) {
        Start-Sleep -Seconds 3
        $pollJson = databricks api get "/api/2.0/sql/statements/$statementId" -p $Profile --output json
        $response = $pollJson | ConvertFrom-Json
        $state = $response.status.state
    }

    if ($state -ne "SUCCEEDED") {
        $message = $response.status.error.message
        if (-not $message) {
            $message = ($response.status | ConvertTo-Json -Compress)
        }
        throw "SQL statement failed with state '$state': $message"
    }

    return $response
}

if (-not (Test-Path -LiteralPath $SqlFile)) {
    throw "SQL file not found: $SqlFile"
}

if (-not $WarehouseId) {
    $WarehouseId = Get-DefaultWarehouseId -Profile $Profile
}

$sqlText = Get-Content -LiteralPath $SqlFile -Raw
$statements = Split-SqlStatements -SqlText $sqlText

Write-Host "Running file: $SqlFile"
Write-Host "Profile: $Profile"
Write-Host "Warehouse: $WarehouseId"
Write-Host "Statements: $($statements.Count)"

$index = 0
foreach ($statement in $statements) {
    $index++
    $preview = ($statement -replace "\s+", " ").Trim()
    if ($preview.Length -gt 100) {
        $preview = $preview.Substring(0, 100) + "..."
    }

    Write-Host "[$index/$($statements.Count)] $preview"
    Invoke-DatabricksSql `
        -Statement $statement `
        -Profile $Profile `
        -WarehouseId $WarehouseId `
        -Catalog $Catalog `
        -Schema $Schema `
        -WaitTimeoutSeconds $WaitTimeoutSeconds | Out-Null
}

Write-Host "OK: $SqlFile"
