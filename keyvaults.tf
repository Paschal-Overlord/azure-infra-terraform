resource "random_password" "mysql_admin" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "!#$%&()*+,-./:;<=>?@[]^_{|}~"
}

resource "azurerm_key_vault" "app_kv" {
  name                      = var.key_vault_name
  location                  = data.azurerm_resource_group.app_rg.location
  resource_group_name       = data.azurerm_resource_group.app_rg.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }

  tags = {
    Environment = var.environment
    Purpose     = "Secrets Management"
  }
}

# Terraform runner gets Secrets Officer so it can write secrets at apply time
resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.app_kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# DevOps group gets Secrets User — read-only access to all secrets
resource "azurerm_role_assignment" "kv_group_access" {
  scope                = azurerm_key_vault.app_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_group.devops_group.object_id
}

resource "azurerm_key_vault_secret" "mysql_admin_password" {
  name         = "mysql-admin-password"
  value        = random_password.mysql_admin.result
  key_vault_id = azurerm_key_vault.app_kv.id

  # Must wait for role assignment before writing — otherwise Terraform races ahead
  # and fails with a permissions error
  depends_on = [azurerm_role_assignment.kv_secrets_officer]

  tags = {
    Environment = var.environment
    Service     = "MySQL"
  }
}
