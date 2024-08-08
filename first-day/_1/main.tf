// I'm a comment
# Me too :D

# This is a Terraform configuration file
# It's written in HashiCorp Configuration Language (HCL)



# This block is a Terraform block - it configures the parameter of Terraform for this project
terraform {
    # Here you specify which provider you want to use
    # A provider is a plugin that Terraform uses to interact with services like Azure, AWS, GCP, etc. - but also on-premises services are supported
    # You can use multiple providers in a single configuration file
    required_providers {

        # This block is for the Azure provider
        azurerm = {
            source = "hashicorp/azurerm" # This line tells the provider where to get the plugin. In this case, it's the Terraform Registry (https://registry.terraform.io/)
            version = "3.118.0" # This line specifies the version of the plugin. You can use a specific version or a version constraint
            # version = "~> 3.0" # This line specifies a version constraint. In this case, it means that Terraform will use the latest version of the plugin that is compatible with version 3.0
            # version = ">= 3.0" # This line specifies a version constraint. In this case, it means that Terraform will use the latest version of the plugin that is greater than or equal to version 3.0
            # version = "< 3.0" # This line specifies a version constraint. In this case, it means that Terraform will use the latest version of the plugin that is less than version 3.0
        }

        # Just a few other providers. Concept is the same as for the Azure provider
        aws = {
            source = "hashicorp/aws"
            version = "3.56.0"
        }

        fortios = {
            source = "fortinet/fortios"
            version = "0.1.0"
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
    #backend "azurerm" {
    #    resource_group_name  = "first-day-rg"
    #    storage_account_name = "firstdaystorage"
    #    container_name       = "tfstate"
    #    key                  = "terraform.tfstate"
    #}

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

resource "azurerm_resource_group" "rg" {
    name     = "first-day-rg" # I'm a argument
    location = "westeurope"
}