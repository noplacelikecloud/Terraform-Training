terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.118.0"
        }
    }

    backend "local" {
        path = "terraform.tfstate"
    }
}
