terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }

  # Remote state — keeps state off local machines and prevents conflicts
  # when multiple team members run terraform apply
  backend "azurerm" {
    resource_group_name  = "<your-tfstate-resource-group>"
    storage_account_name = "<your-tfstate-storage-account>"
    container_name       = "<your-tfstate-container>"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
