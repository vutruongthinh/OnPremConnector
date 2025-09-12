# Import Existing Resources Script
# This script lists all resources in the resource group and imports them into Terraform state

param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName = "rg-vincent-southeastasia",
    
    [Parameter(Mandatory = $false)]
    [switch]$ListOnly = $false,
    
    [Parameter(Mandatory = $false)]
    [switch]$DryRun = $false
)

Write-Host "=== Azure Resource Import Script ===" -ForegroundColor Green
Write-Host "Resource Group: $ResourceGroupName" -ForegroundColor Cyan

# Check if user is logged in to Azure
Write-Host "`nChecking Azure login status..." -ForegroundColor Yellow
try {
    $account = az account show 2>$null | ConvertFrom-Json
    if (-not $account) {
        Write-Host "Not logged in to Azure. Please run 'az login' first." -ForegroundColor Red
        exit 1
    }
    Write-Host "Logged in as: $($account.user.name)" -ForegroundColor Green
    Write-Host "Subscription: $($account.name) ($($account.id))" -ForegroundColor Green
}
catch {
    Write-Host "Error checking Azure login status. Please run 'az login' first." -ForegroundColor Red
    exit 1
}

# Check if resource group exists
Write-Host "`nChecking if resource group exists..." -ForegroundColor Yellow
$rgExists = az group exists --name $ResourceGroupName
if ($rgExists -eq "false") {
    Write-Host "Resource group '$ResourceGroupName' does not exist!" -ForegroundColor Red
    exit 1
}
Write-Host "Resource group exists ✓" -ForegroundColor Green

# Get subscription ID
$subscriptionId = $account.id

# List all resources in the resource group
Write-Host "`nListing resources in resource group..." -ForegroundColor Yellow
$resources = az resource list --resource-group $ResourceGroupName | ConvertFrom-Json

if ($resources.Count -eq 0) {
    Write-Host "No resources found in resource group '$ResourceGroupName'" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($resources.Count) resources:" -ForegroundColor Green

# Resource mapping for Terraform
$resourceMapping = @{
    "Microsoft.Network/virtualNetworks"                     = @{
        terraform_type = "azurerm_virtual_network"
        terraform_name = "main"
    }
    "Microsoft.Network/virtualNetworks/subnets"             = @{
        terraform_type      = "azurerm_subnet"
        terraform_name_func = { param($resource) 
            if ($resource.name -like "*pe*") { "pe_subnet" }
            elseif ($resource.name -like "*web*") { "web_subnet" }
            else { $resource.name -replace "[^a-zA-Z0-9_]", "_" }
        }
    }
    "Microsoft.Storage/storageAccounts"                     = @{
        terraform_type = "azurerm_storage_account"
        terraform_name = "main"
    }
    "Microsoft.CognitiveServices/accounts"                  = @{
        terraform_type = "azurerm_cognitive_account"
        terraform_name = "openai"
    }
    "Microsoft.Search/searchServices"                       = @{
        terraform_type = "azurerm_search_service"
        terraform_name = "main"
    }
    "Microsoft.DBforPostgreSQL/flexibleServers"             = @{
        terraform_type = "azurerm_postgresql_flexible_server"
        terraform_name = "main"
    }
    "Microsoft.Web/serverfarms"                             = @{
        terraform_type = "azurerm_service_plan"
        terraform_name = "main"
    }
    "Microsoft.Web/sites"                                   = @{
        terraform_type      = "azurerm_linux_web_app"
        terraform_name_func = { param($resource) 
            if ($resource.name -like "*frontend*") { "frontend" }
            elseif ($resource.name -like "*backend*") { "backend" }
            else { $resource.name -replace "[^a-zA-Z0-9_]", "_" }
        }
    }
    "Microsoft.Network/privateEndpoints"                    = @{
        terraform_type      = "azurerm_private_endpoint"
        terraform_name_func = { param($resource) 
            $baseName = $resource.name -replace "-pe$", ""
            if ($baseName -like "*openai*") { "openai" }
            elseif ($baseName -like "*search*") { "search" }
            elseif ($baseName -like "*storage*") { "storage" }
            elseif ($baseName -like "*postgres*") { "postgres" }
            elseif ($baseName -like "*frontend*") { "frontend[0]" }
            elseif ($baseName -like "*backend*") { "backend[0]" }
            else { $baseName -replace "[^a-zA-Z0-9_]", "_" }
        }
    }
    "Microsoft.Network/privateDnsZones"                     = @{
        terraform_type      = "azurerm_private_dns_zone"
        terraform_name_func = { param($resource) 
            switch -Wildcard ($resource.name) {
                "*openai*" { "openai" }
                "*search*" { "search" }
                "*blob*" { "storage_blob" }
                "*postgres*" { "postgres" }
                "*azurewebsites*" { "webapp" }
                default { $resource.name -replace "[^a-zA-Z0-9_]", "_" }
            }
        }
    }
    "Microsoft.Network/privateDnsZones/virtualNetworkLinks" = @{
        terraform_type      = "azurerm_private_dns_zone_virtual_network_link"
        terraform_name_func = { param($resource) 
            $zoneName = ($resource.id -split "/")[-3]
            switch -Wildcard ($zoneName) {
                "*openai*" { "openai" }
                "*search*" { "search" }
                "*blob*" { "storage_blob" }
                "*postgres*" { "postgres" }
                "*azurewebsites*" { "webapp" }
                default { $zoneName -replace "[^a-zA-Z0-9_]", "_" }
            }
        }
    }
}

# Display resources
foreach ($resource in $resources) {
    $resourceType = $resource.type
    $resourceName = $resource.name
    $resourceId = $resource.id
    
    Write-Host "`n📦 Resource: $resourceName" -ForegroundColor Cyan
    Write-Host "   Type: $resourceType" -ForegroundColor Gray
    Write-Host "   ID: $resourceId" -ForegroundColor Gray
    
    # Check if we have mapping for this resource type
    if ($resourceMapping.ContainsKey($resourceType)) {
        $mapping = $resourceMapping[$resourceType]
        $terraformType = $mapping.terraform_type
        
        # Get Terraform resource name
        if ($mapping.terraform_name) {
            $terraformName = $mapping.terraform_name
        }
        elseif ($mapping.terraform_name_func) {
            $terraformName = & $mapping.terraform_name_func $resource
        }
        else {
            $terraformName = $resourceName -replace "[^a-zA-Z0-9_]", "_"
        }
        
        $terraformAddress = "$terraformType.$terraformName"
        Write-Host "   Terraform: $terraformAddress" -ForegroundColor Green
        
        if (-not $ListOnly) {
            if ($DryRun) {
                Write-Host "   [DRY RUN] Would import: terraform import $terraformAddress `"$resourceId`"" -ForegroundColor Yellow
            }
            else {
                Write-Host "   Importing..." -ForegroundColor Yellow
                
                # Check if already in state
                $stateCheck = terraform state show $terraformAddress 2>$null
                if ($stateCheck) {
                    Write-Host "   ✓ Already in Terraform state" -ForegroundColor Blue
                }
                else {
                    # Import the resource
                    $importResult = terraform import $terraformAddress $resourceId 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        Write-Host "   ✓ Successfully imported" -ForegroundColor Green
                    }
                    else {
                        Write-Host "   ❌ Import failed: $importResult" -ForegroundColor Red
                    }
                }
            }
        }
    }
    else {
        Write-Host "   ⚠️  No Terraform mapping defined for this resource type" -ForegroundColor Yellow
    }
}

if ($ListOnly) {
    Write-Host "`n📋 List complete. Use -ListOnly:`$false to import resources." -ForegroundColor Cyan
}
elseif ($DryRun) {
    Write-Host "`n🧪 Dry run complete. Remove -DryRun to actually import resources." -ForegroundColor Cyan
}
else {
    Write-Host "`n✅ Import process completed!" -ForegroundColor Green
    Write-Host "Run 'terraform plan' to see what changes would be made." -ForegroundColor Yellow
}

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Green
Write-Host "Resources found: $($resources.Count)" -ForegroundColor Cyan
$mappedCount = ($resources | Where-Object { $resourceMapping.ContainsKey($_.type) }).Count
Write-Host "Resources with Terraform mapping: $mappedCount" -ForegroundColor Cyan
$unmappedCount = $resources.Count - $mappedCount
if ($unmappedCount -gt 0) {
    Write-Host "Resources without mapping: $unmappedCount" -ForegroundColor Yellow
}