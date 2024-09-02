provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}

  subscription_id = "00000000-0000-0000-0000-000000000000" # Subscription ID of the hub subscription
  alias = "hub" # Alias for the hub subscription
  
}