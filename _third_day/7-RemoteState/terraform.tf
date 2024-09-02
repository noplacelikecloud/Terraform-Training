terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "rg-tf-state-prod"
    storage_account_name  = "sttfstatebeflax"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }

}