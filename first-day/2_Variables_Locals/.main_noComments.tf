terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  type    = string
  default = "first-day-rg"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }

  description = "The name of the resource group."
}

locals {
  location = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = local.location
}