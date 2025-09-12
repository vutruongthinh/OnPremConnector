# Simple Resource Lister
# This script just lists resources in the resource group

param(
    [string]$ResourceGroupName = "rg-vincent-southeastasia"
)

Write-Host "=== Resources in $ResourceGroupName ===" -ForegroundColor Green

# Check Azure login
try {
    $account = az account show 2>$null | ConvertFrom-Json
    if (-not $account) {
        Write-Host "Please run 'az login' first" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "Please run 'az login' first" -ForegroundColor Red
    exit 1
}

# List resources
$resources = az resource list --resource-group $ResourceGroupName | ConvertFrom-Json

if ($resources.Count -eq 0) {
    Write-Host "No resources found in '$ResourceGroupName'" -ForegroundColor Yellow
    Write-Host "Create the resource group first with:" -ForegroundColor Cyan
    Write-Host "az group create --name '$ResourceGroupName' --location 'southeastasia'" -ForegroundColor White
    exit 0
}

Write-Host "Found $($resources.Count) resources:`n" -ForegroundColor Cyan

foreach ($resource in $resources) {
    Write-Host "📦 $($resource.name)" -ForegroundColor Yellow
    Write-Host "   Type: $($resource.type)" -ForegroundColor Gray
    Write-Host "   Location: $($resource.location)" -ForegroundColor Gray
    Write-Host ""
}

Write-Host "To import these resources into Terraform, run:" -ForegroundColor Green
Write-Host ".\import-resources.ps1 -ResourceGroupName '$ResourceGroupName'" -ForegroundColor White