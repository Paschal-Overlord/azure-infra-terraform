resource "azurerm_storage_account" "app_filestorage" {
  name                     = "${var.app_name}${var.environment}filestorage"
  resource_group_name      = data.azurerm_resource_group.app_rg.name
  location                 = data.azurerm_resource_group.app_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_container" "file_storage" {
  name                  = "${var.app_name}-${var.environment}-files"
  storage_account_name  = azurerm_storage_account.app_filestorage.name
  container_access_type = "private"
}
