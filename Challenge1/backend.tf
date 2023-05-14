terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name  = "kpmp-int-lz"
    storage_account_name = "kpmp-int-lz"
    container_name       = "terraformtfstate"
    key                  = "terraform.tfstate"
  }
}
