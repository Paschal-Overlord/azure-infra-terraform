resource "azurerm_virtual_network" "app_vnet" {
  name                = "${var.app_name}-${var.environment}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.app_rg.location
  resource_group_name = data.azurerm_resource_group.app_rg.name
}

resource "azurerm_subnet" "vm_subnet" {
  name                 = "${var.app_name}-${var.environment}-vm-subnet"
  resource_group_name  = data.azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "mysql_subnet" {
  name                 = "${var.app_name}-${var.environment}-mysql-subnet"
  resource_group_name  = data.azurerm_resource_group.app_rg.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "mysql"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = "${var.app_name}-${var.environment}-lb-public-ip"
  location            = data.azurerm_resource_group.app_rg.location
  resource_group_name = data.azurerm_resource_group.app_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_security_group" "app_nsg" {
  name                = "${var.app_name}-${var.environment}-nsg"
  location            = data.azurerm_resource_group.app_rg.location
  resource_group_name = data.azurerm_resource_group.app_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-80"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-Backend"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080-8086"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP-Frontend"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000-3006"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_network_interface" "app_nic" {
  name                = "${var.app_name}-${var.environment}-vm-nic"
  location            = data.azurerm_resource_group.app_rg.location
  resource_group_name = data.azurerm_resource_group.app_rg.name

  ip_configuration {
    name                          = "app-nic-config"
    subnet_id                     = azurerm_subnet.vm_subnet.id
    private_ip_address_allocation = "Static"
    public_ip_address_id          = azurerm_public_ip.app_public_ip.id
  }
}

resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}
