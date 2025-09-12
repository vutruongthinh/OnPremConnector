variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "southeastasia"
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "example-vnet"
}

variable "pe_subnet_name" {
  description = "Name of the private endpoint subnet"
  type        = string
  default     = "pe_subnet"
}

variable "web_subnet_name" {
  description = "Name of the web subnet"
  type        = string
  default     = "web_subnet"
}

variable "address_space" {
  description = "Address space for the VNET"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "pe_subnet_prefix" {
  description = "Address prefix for pe_subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "web_subnet_prefix" {
  description = "Address prefix for web_subnet"
  type        = string
  default     = "10.0.2.0/24"
}

# Azure OpenAI variables
variable "openai_name" {
  description = "Name of the Azure OpenAI service"
  type        = string
  default     = "example-openai"
}

variable "openai_sku" {
  description = "SKU for Azure OpenAI service"
  type        = string
  default     = "S0"
}

# Azure AI Search variables
variable "search_service_name" {
  description = "Name of the Azure AI Search service"
  type        = string
  default     = "example-search"
}

variable "search_sku" {
  description = "SKU for Azure AI Search service"
  type        = string
  default     = "basic"
}

# Storage Account variables
variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
  default     = "examplestorage"
}

variable "storage_account_tier" {
  description = "Tier for the storage account"
  type        = string
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Replication type for the storage account"
  type        = string
  default     = "LRS"
}

# PostgreSQL variables
variable "postgres_server_name" {
  description = "Name of the PostgreSQL server"
  type        = string
  default     = "example-postgres"
}

variable "postgres_version" {
  description = "Version of PostgreSQL"
  type        = string
  default     = "13"
}

variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL"
  type        = string
  default     = "pgadmin"
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL"
  type        = string
  sensitive   = true
}

variable "postgres_storage_mb" {
  description = "Storage size in MB for PostgreSQL"
  type        = number
  default     = 32768
}

variable "postgres_sku_name" {
  description = "SKU name for PostgreSQL"
  type        = string
  default     = "B_Standard_B1ms"
}

# App Service variables
variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "asp-example"
}

variable "app_service_plan_sku" {
  description = "SKU for the App Service Plan (Standard or higher for VNet integration)"
  type        = string
  default     = "S1"
}

variable "frontend_webapp_name" {
  description = "Name of the frontend web app"
  type        = string
  default     = "webapp-frontend-example"
}

variable "backend_webapp_name" {
  description = "Name of the backend web app"
  type        = string
  default     = "webapp-backend-example"
}

variable "enable_webapp_private_endpoints" {
  description = "Enable private endpoints for web apps"
  type        = bool
  default     = false
}
