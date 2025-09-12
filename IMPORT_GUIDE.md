# Resource Import Scripts Usage Guide

This directory contains scripts to help you manage existing Azure resources with Terraform.

## Scripts Available

### 1. `list-resources.ps1` - Simple Resource Listing
Lists all resources in a resource group.

```powershell
# List resources in default resource group
.\list-resources.ps1

# List resources in specific resource group
.\list-resources.ps1 -ResourceGroupName "my-resource-group"
```

### 2. `import-resources.ps1` - Advanced Import Tool
Lists and imports existing Azure resources into Terraform state.

```powershell
# Just list resources and show what would be imported
.\import-resources.ps1 -ListOnly

# Dry run - show import commands without executing
.\import-resources.ps1 -DryRun

# Actually import resources
.\import-resources.ps1

# Import from specific resource group
.\import-resources.ps1 -ResourceGroupName "my-rg"
```

## Workflow

### Step 1: Login to Azure
```powershell
az login
```

### Step 2: Create Resource Group (if it doesn't exist)
```powershell
az group create --name "rg-vincent-southeastasia" --location "southeastasia"
```

### Step 3: List Existing Resources
```powershell
.\list-resources.ps1
```

### Step 4: Import Resources (Optional)
If you have existing resources you want Terraform to manage:

```powershell
# See what would be imported
.\import-resources.ps1 -ListOnly

# Do a dry run
.\import-resources.ps1 -DryRun

# Actually import
.\import-resources.ps1
```

### Step 5: Initialize and Plan Terraform
```powershell
terraform init
terraform plan
```

### Step 6: Apply Terraform
```powershell
terraform apply
```

## Resource Type Mappings

The import script knows how to map these Azure resource types to Terraform:

| Azure Resource Type | Terraform Resource |
|-------------------|-------------------|
| `Microsoft.Network/virtualNetworks` | `azurerm_virtual_network.main` |
| `Microsoft.Network/virtualNetworks/subnets` | `azurerm_subnet.{pe_subnet\|web_subnet}` |
| `Microsoft.Storage/storageAccounts` | `azurerm_storage_account.main` |
| `Microsoft.CognitiveServices/accounts` | `azurerm_cognitive_account.openai` |
| `Microsoft.Search/searchServices` | `azurerm_search_service.main` |
| `Microsoft.DBforPostgreSQL/flexibleServers` | `azurerm_postgresql_flexible_server.main` |
| `Microsoft.Web/serverfarms` | `azurerm_service_plan.main` |
| `Microsoft.Web/sites` | `azurerm_linux_web_app.{frontend\|backend}` |
| `Microsoft.Network/privateEndpoints` | `azurerm_private_endpoint.*` |
| `Microsoft.Network/privateDnsZones` | `azurerm_private_dns_zone.*` |

## Troubleshooting

### Import Errors
If import fails, you might need to:
1. Check resource naming in `terraform.tfvars`
2. Verify resource configuration matches existing Azure resources
3. Manually adjust Terraform configuration to match existing resources

### Resource Not Found
If a resource isn't found during import:
1. Verify the resource exists in Azure
2. Check you're in the correct subscription
3. Ensure resource group name is correct

### Terraform Plan Shows Changes
After import, if `terraform plan` shows unwanted changes:
1. Review the differences
2. Update your `.tf` files to match the existing resources
3. Use `terraform refresh` to sync state

## Example: Fresh Deployment

```powershell
# 1. Login and create RG
az login
az group create --name "rg-vincent-southeastasia" --location "southeastasia"

# 2. Deploy with Terraform
terraform init
terraform plan
terraform apply

# 3. List what was created
.\list-resources.ps1
```

## Example: Import Existing Resources

```powershell
# 1. Login
az login

# 2. See what exists
.\list-resources.ps1

# 3. Import existing resources
.\import-resources.ps1 -DryRun  # Preview
.\import-resources.ps1          # Actually import

# 4. Plan and apply remaining resources
terraform init
terraform plan
terraform apply
```