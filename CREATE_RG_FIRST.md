# Manual Resource Group Creation

Before running Terraform, create the resource group manually using one of these methods:

## Option 1: Azure Portal
1. Go to https://portal.azure.com
2. Search for "Resource Groups"
3. Click "Create"
4. Fill in:
   - **Resource group name**: `rg-vincent-southeastasia`
   - **Region**: `Southeast Asia`
5. Click "Review + Create" then "Create"

## Option 2: Azure CLI (if installed)
```bash
az group create --name "rg-vincent-southeastasia" --location "southeastasia"
```

## Option 3: PowerShell with Az Module (if installed)
```powershell
New-AzResourceGroup -Name "rg-vincent-southeastasia" -Location "southeastasia"
```

## Verify Resource Group Exists
After creating the resource group, you can proceed with:

```powershell
# Navigate to terraform directory
cd "c:\Users\Thinh\OneDrive - Singapore Management University\AnhTraiAI\OnpremConnect\case5-azure-vnet-terraform"

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

## What Terraform Will Create
With the resource group already existing, Terraform will:
- Use the existing resource group (via data source)
- Create Virtual Network and subnets
- Create Azure OpenAI, AI Search, Storage Account, PostgreSQL
- Create private endpoints for all services
- Create private DNS zones for name resolution
- Create App Service Plan and Web Apps with VNet integration

The data source approach ensures Terraform won't try to create or modify the existing resource group.
