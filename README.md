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

Tuan 15 -  21/9:
    - 
    - Proff 
Tuan 22-28/9: Phase 1 Milestone - MVP
    - So bo hoan thanh Infra tren Azure
    - Cai dat ha tang can thiet on-prem
    - Hoan thanh giao dien frontend + ket noi voi backend
    - Demo chatbot voi bo test docs (host tren Azure)
    - Tap trung vao 2 cau hoi 
    
Du kien muc tieu Phase 2 (den 30/10):
    - Hoan thanh thiet lap ket noi onprem - Azure cho 2 luong: upload va user query
    - Hoan thanh xay dung infra can thiet onprem.
    - Xu ly luong bao cao thuc. Luu tru du lieu da qua xu ly vao onprem database va Azure AI search
    - Fine-tune chatbot de dua ra cau tra loi chinh xac hon
    - Ra soat cac phuong an security
    - QA testing

Onprem:
    - Phu trach chinh: Thang + Thinh
    - Tien do hien tai: da nhan VPN tu KTNN/ chunker code da co tren github
    - Cac task tiep theo:
        - Phan tich ha tang can cai dat onPrem va do kha thi: 
            Postgres DB (schema/install sql code)?
            Runtime can thiet de chay chunker?
            Tai khoan service account de chay process onprem? Cac permissions can thiet cho account nay?
            Mo 1 firewall inbound port de nhan GET request tu user query?
        - Test connectivity tu onprem <-> Azure:
            Upload flow: POST request tu Onprem -> Azure, xac nhan code 200 OK
            Query flow: GET request tu Azure -> Onprem, xac nhan code 200 OK
        - 


     
