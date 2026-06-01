data "azurerm_client_config" "current" {}

data "azuread_group" "devops_group" {
  display_name = var.devops_group_name
}

data "azurerm_resource_group" "app_rg" {
  name = var.resource_group_name
}

data "azurerm_ssh_public_key" "app_ssh" {
  name                = var.ssh_key_name
  resource_group_name = data.azurerm_resource_group.app_rg.name
}
