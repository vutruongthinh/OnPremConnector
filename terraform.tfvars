resource_group_name = "rg-vincent-southeastasia"

# Network configuration
vnet_name         = "vnet-vincent"
pe_subnet_name    = "pe_subnet"
web_subnet_name   = "web_subnet"
address_space     = ["10.0.0.0/16"]
pe_subnet_prefix  = "10.0.1.0/24"
web_subnet_prefix = "10.0.2.0/24"

# Azure OpenAI
openai_name = "openai-vincent-sea"
openai_sku  = "S0"

# Azure AI Search
search_service_name = "search-vincent-sea"
search_sku          = "basic"

# Storage Account (must be globally unique)
storage_account_name     = "stexamplesea001"
storage_account_tier     = "Standard"
storage_replication_type = "LRS"

# PostgreSQL
postgres_server_name    = "postgres-example-sea"
postgres_version        = "13"
postgres_admin_username = "pgadmin"
postgres_admin_password = "P@ssw0rd123!"
postgres_storage_mb     = 32768
postgres_sku_name       = "B_Standard_B1ms"

# App Service
app_service_plan_name           = "asp-example-sea"
app_service_plan_sku            = "S1"
frontend_webapp_name            = "webapp-frontend-sea-001"
backend_webapp_name             = "webapp-backend-sea-001"
enable_webapp_private_endpoints = false
