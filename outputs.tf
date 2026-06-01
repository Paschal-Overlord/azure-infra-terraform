output "mysql_server_fqdn" {
  description = "MySQL Flexible Server fully qualified domain name"
  value       = azurerm_mysql_flexible_server.app_db.fqdn
}

output "container_registry_login_server" {
  description = "ACR login server endpoint"
  value       = azurerm_container_registry.app_acr.login_server
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.app_filestorage.name
}

output "load_balancer_public_ip" {
  description = "VM public IP address"
  value       = azurerm_public_ip.app_public_ip.ip_address
}

output "key_vault_uri" {
  description = "Key Vault URI for use in application config"
  value       = azurerm_key_vault.app_kv.vault_uri
}

output "mysql_admin_password" {
  description = "Auto-generated MySQL admin password (stored in Key Vault)"
  value       = random_password.mysql_admin.result
  sensitive   = true
}
