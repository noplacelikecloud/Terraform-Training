
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.115.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }

    fortios = {
      source  = "fortinet/fortios"
      version = "1.20.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }

}


provider "azurerm" {
  features {}
  subscription_id = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
}


resource "azurerm_resource_group" "rg" {
  name     = "first-day-rg"
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-test-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  address_space       = ["10.0.0.0/24"]

  subnet {
    name           = "vm-subnet"
    address_prefix = "10.0.0.0/27"
  }

  subnet {
    name           = "app-subnet"
    address_prefix = "10.0.0.64/27"
  }
}


output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}