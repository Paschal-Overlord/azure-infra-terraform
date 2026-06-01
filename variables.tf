# -----------------------------------------------------------------------------
# Required
# -----------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Name of the existing Azure resource group to deploy into"
  type        = string
}

variable "app_name" {
  description = "Short application name used as a prefix across all resource names (e.g. 'myapp')"
  type        = string
}

variable "environment" {
  description = "Deployment environment — used in resource names and tags (e.g. 'dev', 'staging', 'prod')"
  type        = string
  default     = "dev"
}

# -----------------------------------------------------------------------------
# Networking
# -----------------------------------------------------------------------------

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "vm_subnet_prefix" {
  description = "Address prefix for the VM subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "mysql_subnet_prefix" {
  description = "Address prefix for the MySQL delegated subnet"
  type        = string
  default     = "10.0.3.0/24"
}

# -----------------------------------------------------------------------------
# Virtual Machine
# -----------------------------------------------------------------------------

variable "vm_admin_username" {
  description = "Admin username for the Linux VM"
  type        = string
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "ssh_key_name" {
  description = "Name of the existing Azure SSH Public Key resource"
  type        = string
}

variable "managed_identity_id" {
  description = "Resource ID of the User-Assigned Managed Identity to attach to the VM"
  type        = string
}

# -----------------------------------------------------------------------------
# Database
# -----------------------------------------------------------------------------

variable "mysql_admin_username" {
  description = "MySQL Flexible Server administrator login"
  type        = string
  default     = "dbadmin"
}

# -----------------------------------------------------------------------------
# Key Vault
# -----------------------------------------------------------------------------

variable "key_vault_name" {
  description = "Name for the Azure Key Vault (must be globally unique)"
  type        = string
}

# -----------------------------------------------------------------------------
# Access control
# -----------------------------------------------------------------------------

variable "devops_group_name" {
  description = "Display name of the Azure AD group that will receive Key Vault Secrets User access"
  type        = string
}
