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

resource "azurerm_resource_group" "rg" { 
  name     = "first-day-rg"              
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-test-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westeurope"
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "internal" {
  name = "internal"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/27"]
}

resource "azurerm_network_interface" "if" {
  name = "linux-nic"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "testconfig"
    subnet_id = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = "linux-vm"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.if.id]
  size = "Standard_F2"
  admin_username = "adminuser"
  admin_password = "Pass1234!"
  disable_password_authentication = false

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_storage_account" "name" {
  name = "storedge"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  
}

resource "azurerm_private_endpoint" "name" {
  name = "storage-endpoint"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id = azurerm_subnet.internal.id
  

  private_service_connection {
    name = "storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.name.id
    is_manual_connection = false
    subresource_names = ["blob"]
  }
}