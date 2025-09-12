output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}

output "pe_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = azurerm_subnet.pe_subnet.id
}

output "web_subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.web_subnet.id
}

output "openai_endpoint" {
  description = "Azure OpenAI endpoint"
  value       = azurerm_cognitive_account.openai.endpoint
  sensitive   = true
}

output "openai_private_endpoint_ip" {
  description = "Private IP address of Azure OpenAI private endpoint"
  value       = azurerm_private_endpoint.openai.private_service_connection[0].private_ip_address
}

output "search_service_url" {
  description = "Azure AI Search service URL"
  value       = "https://${azurerm_search_service.main.name}.search.windows.net"
}

output "search_private_endpoint_ip" {
  description = "Private IP address of Azure AI Search private endpoint"
  value       = azurerm_private_endpoint.search.private_service_connection[0].private_ip_address
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_private_endpoint_ip" {
  description = "Private IP address of Storage Account private endpoint"
  value       = azurerm_private_endpoint.storage.private_service_connection[0].private_ip_address
}

output "postgres_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
  sensitive   = true
}

output "postgres_private_endpoint_ip" {
  description = "Private IP address of PostgreSQL private endpoint"
  value       = azurerm_private_endpoint.postgres.private_service_connection[0].private_ip_address
}

output "private_dns_zones" {
  description = "Private DNS zones created"
  value = {
    openai   = azurerm_private_dns_zone.openai.name
    search   = azurerm_private_dns_zone.search.name
    storage  = azurerm_private_dns_zone.storage_blob.name
    postgres = azurerm_private_dns_zone.postgres.name
    webapp   = azurerm_private_dns_zone.webapp.name
  }
}

# Web App outputs
output "app_service_plan_id" {
  description = "ID of the App Service Plan"
  value       = azurerm_service_plan.main.id
}

output "frontend_webapp_url" {
  description = "URL of the frontend web app"
  value       = "https://${azurerm_linux_web_app.frontend.default_hostname}"
}

output "backend_webapp_url" {
  description = "URL of the backend web app"
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
}

output "frontend_webapp_name" {
  description = "Name of the frontend web app"
  value       = azurerm_linux_web_app.frontend.name
}

output "backend_webapp_name" {
  description = "Name of the backend web app"
  value       = azurerm_linux_web_app.backend.name
}

output "frontend_private_endpoint_ip" {
  description = "Private IP address of Frontend Web App private endpoint"
  value       = var.enable_webapp_private_endpoints ? azurerm_private_endpoint.frontend[0].private_service_connection[0].private_ip_address : null
}

output "backend_private_endpoint_ip" {
  description = "Private IP address of Backend Web App private endpoint"
  value       = var.enable_webapp_private_endpoints ? azurerm_private_endpoint.backend[0].private_service_connection[0].private_ip_address : null
}
