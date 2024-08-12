// I'm a comment
# Me too :D

# This is a Terraform configuration file
# It's written in HashiCorp Configuration Language (HCL)

# You can find the complete documentation of the Azure provider here: https://developer.hashicorp.com/terraform/language


# This block is a Terraform block - it configures the parameter of Terraform for this project
terraform {
  # Here you specify which provider you want to use
  # A provider is a plugin that Terraform uses to interact with services like Azure, AWS, GCP, etc. - but also on-premises services are supported
  # You can use multiple providers in a single configuration file
  required_providers {

    # This block is for the Azure provider
    azurerm = {
      source  = "hashicorp/azurerm" # This line tells the provider where to get the plugin. In this case, it's the Terraform Registry (https://registry.terraform.io/)
      version = "3.115.0"           # This line specifies the version of the plugin. You can use a specific version or a version constraint
      # version = "~> 3.0" # This line specifies a version constraint. In this case, it means that Terraform will use the latest version of the plugin that is compatible with version 3.0
      # version = ">= 3.0" # This line specifies a version constraint. In this case, it means that Terraform will use the latest version of the plugin that is greater than or equal to version 3.0
      # version = "< 3.0" # This line specifies a version constraint. In this case, it means that Terraform will use the latest version of the plugin that is less than version 3.0
    }

    # Just a few other providers. Concept is the same as for the Azure provider
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }

    fortios = {
      source  = "fortinetdev/fortios"
      version = "1.20.0"
    }
  }

  # This block is for the backend configuration. It tells Terraform where to store the state file
  # The state file is a file that contains the current state of your infrastructure
  # It'll be locked when you run Terraform commands to prevent conflicts
  backend "local" {
    path = "terraform.tfstate"
  }

  # To share the state file with your team, you can use a remote backend
  # Here's an example of using Azure Blob Storage as a remote backend
  # backend "azurerm" {
  #    resource_group_name  = "first-day-rg"
  #    storage_account_name = "firstdaystorage"
  #    container_name       = "tfstate"
  #    key                  = "terraform.tfstate"
  # }

  # You can also use other remote backends like AWS S3, Google Cloud Storage, etc.
}

# This block is for the Azure provider configuration
# It tells Terraform the configuration of the Azure provider - like authentication, etc.
provider "azurerm" {
  features {}

  # Here you can specify the authentication details for the Azure provider
  subscription_id = "00000000-0000-0000-0000-000000000000" # I declare the subscription ID
  client_id       = "00000000-0000-0000-0000-000000000000" # I declare the client ID
  client_secret   = "00000000-0000-0000-0000-000000000000" # I declare the client secret
  tenant_id       = "00000000-0000-0000-0000-000000000000" # I declare the tenant ID
}

# This is a resource block. It's used to define a resource in Terraform
resource "azurerm_resource_group" "rg" { # This line specifies the resource type and the resource name. In this case, it's an Azure resource group. It begins with the provider name (azurerm) and the resource type (resource_group). The internal terraform resource name (rg) is specified after the resource type
  name     = "first-day-rg"              # I'm a argument
  location = "westeurope"
}

# Now we're going to create a virtual network and a subnet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-test-01"                 # Note that we're using the local value here
  resource_group_name = azurerm_resource_group.rg.name # and here we're using the variable
  location            = "westeurope"
  address_space       = ["10.0.0.0/24"]

  subnet { # This is a so called "block" - it's a way to group multiple configurations together
    name           = "vm-subnet"
    address_prefix = "10.0.0.0/27"
  }

  subnet { # This is another block. You can have multiple blocks of the same type
    name           = "app-subnet"
    address_prefix = "10.0.0.64/27"
  }

}

# This is an output block. It's used to define the output of the configuration
# You can use the output in other configurations or scripts
output "resource_group_id" {           # This line specifies the output name. In this case, it's the ID of the resource group
  value = azurerm_resource_group.rg.id # This line specifies the value of the output. In this case, it's the ID of the resource group. Note that we're using the resource group resource here to get the ID
}