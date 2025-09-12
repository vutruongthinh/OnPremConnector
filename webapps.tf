# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
}

# Frontend Web App
resource "azurerm_linux_web_app" "frontend" {
  name                = var.frontend_webapp_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "BACKEND_API_URL"                     = "https://${var.backend_webapp_name}.azurewebsites.net"
  }

  # VNet Integration for outbound traffic
  virtual_network_subnet_id = azurerm_subnet.web_subnet.id
}

# Backend Web App
resource "azurerm_linux_web_app" "backend" {
  name                = var.backend_webapp_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on = false

    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DATABASE_CONNECTION_STRING"          = "postgresql://${var.postgres_admin_username}:${var.postgres_admin_password}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/postgres"
    "STORAGE_ACCOUNT_NAME"                = azurerm_storage_account.main.name
  }

  # VNet Integration for outbound traffic
  virtual_network_subnet_id = azurerm_subnet.web_subnet.id
}

# Private DNS Zone for Web Apps (optional - for private endpoints)
resource "azurerm_private_dns_zone" "webapp" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.main.name
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "webapp" {
  name                  = "webapp-link"
  resource_group_name   = azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.webapp.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# Private Endpoint for Frontend (optional)
resource "azurerm_private_endpoint" "frontend" {
  count               = var.enable_webapp_private_endpoints ? 1 : 0
  name                = "${var.frontend_webapp_name}-pe"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${var.frontend_webapp_name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.frontend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "frontend-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapp.id]
  }
}

# Private Endpoint for Backend (optional)
resource "azurerm_private_endpoint" "backend" {
  count               = var.enable_webapp_private_endpoints ? 1 : 0
  name                = "${var.backend_webapp_name}-pe"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "${var.backend_webapp_name}-psc"
    private_connection_resource_id = azurerm_linux_web_app.backend.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "backend-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.webapp.id]
  }
}
