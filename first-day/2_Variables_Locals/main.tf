// I'm a comment
# Me too :D

# This is a Terraform configuration file
# It's written in HashiCorp Configuration Language (HCL)



# This block is a Terraform block - it configures the parameter of Terraform for this project
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


provider "azurerm" {
    features {}
}

# This defines an input variable named "resource_group_name". You can compare it with "param" in Azure Bicep.
variable "resource_group_name" {
    type    = string # This line specifies the type of the variable. In this case, it's a string. You can also use number, bool, list, map, object, or any
    default = "first-day-rg" # This line specifies the default value of the variable. If you don't provide a value when running Terraform commands, this value will be used

    # This block is for validation. It checks if the value of the variable meets the condition
    validation {
        condition     = length(var.resource_group_name) > 0 # This line specifies the condition. In this case, it checks if the length of the variable is greater than 0
        error_message = "The resource group name must not be empty." # This line specifies the error message if the condition is not met
    }

    description = "The name of the resource group." # This line specifies the description of the variable
  
}

# This is the local block. It defines a local value that can be used within the configuration file. You can compare it with var in Azure Bicep.
locals {
    location = "westeurope"
}

resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name  # Here we use the variable "resource_group_name". If you use a variable in a resource block, you need to prefix it with "var."
    location = local.location           # Here we use the local value "location". If you use a local value in a resource block, you need to prefix it with "local."
}