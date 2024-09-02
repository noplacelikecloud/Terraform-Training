variable "resource_group_name" {
  type    = string
  default = "demo-vm-tf-rg"

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must not be empty."
  }

  description = "The name of the resource group."

}

variable "virutal_machine_name" {
  type        = string
  description = "The name of the virtual machine."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the virtual network."
}

variable "storage_account_as_fileserver" {
  type        = bool
  description = "If true, a storage account will be created to be used as a file server."
}

locals {
  location = "westeurope"
  tags = {
    environment = "dev"
    cost_center = "it"
  }

  subnets = [
    {
      name           = "vm-subnet"
      address_prefix = "10.0.0.0/27"
    },
    {
      name           = "app-subnet"
      address_prefix = "10.0.0.64/27"
    }
  ]
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = local.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  address_space       = ["10.0.0.0/24"]

  dynamic "subnet" { # This is a dynamic block. It's used to create multiple blocks based on a list
    for_each = local.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
    }
  }

}

data "azurerm_subnet" "vm-subnet" {                        
  name                 = "vm-subnet"                       
  virtual_network_name = azurerm_virtual_network.vnet.name 
  resource_group_name  = azurerm_resource_group.rg.name          

  depends_on = [azurerm_virtual_network.vnet]
}


module "vm" {
  source = "./modules/vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  vm_name             = var.virutal_machine_name
  administrator_login = "localadmin"
  availability_zone   = 1

  subnet_id = data.azurerm_subnet.vm-subnet.id

  data_disks = []

  depends_on = [azurerm_virtual_network.vnet, data.azurerm_subnet.vm-subnet]
}

resource "azurerm_storage_account" "st-test" {
  count                    = var.storage_account_as_fileserver ? 1 : 0
  name                     = "sttest"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}