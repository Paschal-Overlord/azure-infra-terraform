resource "azurerm_container_registry" "app_acr" {
  name                = "${var.app_name}${var.environment}acr"
  resource_group_name = data.azurerm_resource_group.app_rg.name
  location            = data.azurerm_resource_group.app_rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    Environment = var.environment
    Purpose     = "Development"
  }
}
