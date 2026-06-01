resource "azurerm_mysql_flexible_server" "app_db" {
  name                   = "${var.app_name}-${var.environment}-mysql-server"
  resource_group_name    = data.azurerm_resource_group.app_rg.name
  location               = data.azurerm_resource_group.app_rg.location
  administrator_login    = var.mysql_admin_username
  administrator_password = azurerm_key_vault_secret.mysql_admin_password.value
  delegated_subnet_id    = azurerm_subnet.mysql_subnet.id
  sku_name               = "B_Standard_B1s"

  storage {
    size_gb           = 32
    auto_grow_enabled = true
  }

  version               = "8.0.21"
  backup_retention_days = 7

  tags = {
    Environment = var.environment
    Purpose     = "Development"
  }
}
