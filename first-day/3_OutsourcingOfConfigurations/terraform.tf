# This block is a Terraform block - it configures the parameter of Terraform for this project
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