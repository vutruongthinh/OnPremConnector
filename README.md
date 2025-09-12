# Case 5: Azure VNET with Private Endpoints using Terraform

This case demonstrates creating Azure resources with private endpoints connected to a dedicated subnet using Terraform.

## Architecture

This deployment creates:
- 1 Virtual Network (VNET) in Southeast Asia
- 2 Subnets:
  - `pe_subnet`: For private endpoints
  - `web_subnet`: For web resources
- Azure OpenAI service with private endpoint
- Azure AI Search service with private endpoint
- Storage Account with private endpoint
- PostgreSQL Flexible Server with private endpoint
- Private DNS zones for each service
- All services have public IP access disabled

## Prerequisites

1. Azure CLI installed and logged in
2. Terraform installed (>= 1.0)
3. Appropriate Azure permissions to create resources

## Deployment Steps

1. **Initialize Terraform**
   ```bash
   terraform init
   ```

2. **Review and modify variables**
   Edit `terraform.tfvars` file to customize resource names and configurations:
   ```bash
   # Update resource names to be unique
   storage_account_name = "your-unique-storage-name"
   openai_name = "your-openai-name"
   postgres_admin_password = "YourSecurePassword123!"
   ```

3. **Plan the deployment**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **View outputs**
   ```bash
   terraform output
   ```

## Important Notes

- **Storage Account Names**: Must be globally unique, 3-24 characters, lowercase letters and numbers only
- **OpenAI Service**: May require special approval in some regions
- **PostgreSQL Password**: Must meet Azure complexity requirements
- **Private Endpoints**: All services are only accessible through the private network
- **DNS Resolution**: Private DNS zones are automatically configured for proper name resolution

## Resources Created

| Resource Type | Purpose |
|---------------|---------|
| Resource Group | Container for all resources |
| Virtual Network | Network isolation |
| Subnets | Network segmentation |
| Azure OpenAI | AI language models |
| Azure AI Search | Search service |
| Storage Account | Blob storage |
| PostgreSQL Server | Database service |
| Private Endpoints | Secure connectivity |
| Private DNS Zones | Name resolution |

## Connectivity Testing

After deployment, you can test connectivity from a VM in the web_subnet:

1. Deploy a test VM in the web_subnet
2. Test DNS resolution: `nslookup <service-name>.privatelink.<domain>`
3. Test connectivity to services using their private endpoints

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Security Considerations

- All services have public network access disabled
- Services are only accessible through private endpoints
- Network security groups can be added for additional security
- Consider implementing Azure Bastion for secure VM access
