terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.115.0"
        }
    }
}

provider "azurerm" {
  features {}
}


variable "resource_group_name" {
    type = string
    default = "sata-rg-we"
}

variable "location" {
    type = string
    default = "westeurope"
}

variable "vnet_name" {
    type = string
    default = "sata-vnet-we"
}

variable "vnet_address_space" {
    type = list(string)
    default = ["10.1.0.0/16"]
}

variable "subnet_name" {
    type = string
    default = "sata-vm-subnet"
}


variable "subnet_prefix" {
    type = string
    default = "10.0.1.0/24"
}

variable "vm_name" {
    type = string
    default = "sata-vm"
}

variable "vm_size" {
    type = string
    default = "standard_b1s"
}

variable "admin_username" {
    type = string
    default = "salem"
}

variable "admin_password" {
    type = string
    default = "12345-Qwer"
}



variable "storage_account_name" {
    type = string
    default = "satastoragewe033"
}

variable "storage_account_tier" {
    type = string
    default = "Standard"
}

variable "storage_account_type" {
    type = string
    default = "LRS"
}


variable "private_endpoint_name" {
    type = string
    default = "sata-pep-we"
}

variable "private_endpoint_svname" {
    type = string
    default = "sa-privateserviceconnection"
}



variable "dns_zone_name" {
    type = string
    default = "privatelink.blob.core.windows.net"
}




variable "dns_zone_vnet_link_name" {
    type = string
    default = "link1-dns-vnet"
}


resource "azurerm_resource_group" "rg1" {
    name = var.resource_group_name
    location = var.location
}

resource "azurerm_virtual_network" "vnet1" {
    name = var.vnet_name
    resource_group_name = azurerm_resource_group.rg1.name
    location = azurerm_resource_group.rg1.location
    address_space = var.vnet_address_space
}

resource "azurerm_subnet" "subnet1" {
    name = var.subnet_name
    resource_group_name = azurerm_resource_group.rg1.name
    virtual_network_name = azurerm_virtual_network.vnet1.name
    address_prefixes = [var.subnet_prefix]
}


resource "azurerm_network_interface" "nic1" {
    name = "${var.vm_name}-nic"
    location = azurerm_resource_group.rg1.location
    resource_group_name = azurerm_resource_group.rg1.name

    ip_configuration {
       name = "internal"
       subnet_id = azurerm_subnet.subnet1.id
       private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "vm1" {
    name = var.vm_name
    location = azurerm_resource_group.rg1.location
    resource_group_name = azurerm_resource_group.rg1.name
    network_interface_ids = [
       azurerm_network_interface.nic1.id, 
    ]
    size = var.vm_size
    
    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }
    admin_username = var.admin_username
    admin_password = var.admin_password
    disable_password_authentication = false
}


resource "azurerm_storage_account" "sa1" {
    name = var.storage_account_name
    resource_group_name = azurerm_resource_group.rg1.name
    location = azurerm_resource_group.rg1.location
    account_tier = var.storage_account_tier
    account_replication_type = var.storage_account_type
}

resource "azurerm_private_endpoint" "pep1" {
    name = var.private_endpoint_name
    location = azurerm_resource_group.rg1.location
    resource_group_name = azurerm_resource_group.rg1.name
    subnet_id = azurerm_subnet.subnet1.id

    private_service_connection {
        name = var.private_endpoint_svname
        private_connection_resource_id = azurerm_storage_account.sa1.id
        is_manual_connection = false
        subresource_names = ["blob"]
    }
}


resource "azurerm_private_dns_zone" "dnszone1" {
    name = var.dns_zone_name
    resource_group_name = azurerm_resource_group.rg1.name
}

resource "azurerm_private_dns_a_record" "dnsrecord" {
    name = azurerm_storage_account.sa1.name
    zone_name = azurerm_private_dns_zone.dnszone1.name
    resource_group_name = azurerm_resource_group.rg1.name
    ttl = 300
    records = [azurerm_private_endpoint.pep1.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
    name = var.dns_zone_vnet_link_name
    resource_group_name = azurerm_resource_group.rg1.name
    private_dns_zone_name = azurerm_private_dns_zone.dnszone1.name
    virtual_network_id = azurerm_virtual_network.vnet1.id
}

