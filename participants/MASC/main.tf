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
  subscription_id = "38a4f7ac-bb71-4fb8-b91d-bf3ec3a2acac"
}

locals {
  location = "westeurope"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-test"
  location = local.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tf-test-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  address_space       = ["10.0.0.0/24"]

  subnet {
    name           = "vm-tf-test-subnet"
    address_prefix = "10.0.0.0/27"
  }
}

data "azurerm_subnet" "subnet" {
  name = "vm-tf-test-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name

  depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-tf-test-nic-001"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "tf-test-vm-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_A2_v2"
  admin_username      = "adminuser"
  admin_password      = "Password123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

#Can't generate SSH Key. Path must exist first. Depends on VM? Command does't work as with Data Block.

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "xtftestsax"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_private_endpoint" "pep" {
  name                = "tf-test-pep"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "tf-test-psc"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob", "file", "queue", "table"]
    is_manual_connection           = false
  }

#  private_dns_zone_group {
#    name                 = "tf-test-pdns-grp"
#    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_zone.id]
#  }
}

#resource "azurerm_private_dns_zone" "private_dns_zone" {
#  name                = "tftest.blob.core.windows.net"
#  resource_group_name = azurerm_resource_group.rg.name
#}

#resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_link" {
#  name                  = "tf-test-priv-dns-vnet-link"
#  resource_group_name   = azurerm_resource_group.rg.name
#  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
#  virtual_network_id    = azurerm_virtual_network.vnet.id
#}

output "resource_group_id" {
  value = azurerm_resource_group.rg.id
}
