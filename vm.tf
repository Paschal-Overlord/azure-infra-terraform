resource "azurerm_linux_virtual_machine" "app_vm" {
  name                = "${var.app_name}-${var.environment}-vm"
  resource_group_name = data.azurerm_resource_group.app_rg.name
  location            = data.azurerm_resource_group.app_rg.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username

  network_interface_ids = [
    azurerm_network_interface.app_nic.id
  ]

  # Password auth disabled — SSH key only
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = data.azurerm_ssh_public_key.app_ssh.public_key
  }

  os_disk {
    name                 = "${var.app_name}-os-disk-${var.environment}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 100
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # User-Assigned Managed Identity — allows the VM to authenticate to Azure
  # services (Key Vault, ACR) without any stored credentials
  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  tags = {
    Environment = var.environment
  }

  custom_data = base64encode(templatefile("${path.module}/scripts.sh", {}))

  lifecycle {
    ignore_changes = [
      admin_username,
      admin_password,
      source_image_reference,
      size
    ]
  }
}
