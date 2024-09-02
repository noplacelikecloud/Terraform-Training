variable "vm_name" {
  description = "Name of the VM"
}

variable "location" {
  description = "The location/region where the resources will be created."

}

variable "subnet_id" {
  description = "The ID of the subnet."
}

variable "data_disks" {
  description = "The data disks to attach to the VM."
  type = list(object({
    disk_size_gb = number
    sku          = string
  }))
}

variable "resource_group_name" {
  description = "The name of the resource group."
}

variable "image_reference" {
  description = "The image reference for the VM."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })

  default = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-hotpatch"
    version   = "latest"
  }

}

variable "availability_zone" {
  description = "The availability zone for the VM."
  type        = number
}

variable "administrator_login" {
  type        = string
  description = "The administrator login for the VM."
}

resource "random_password" "vm-password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

data "azurerm_subnet" "snet" {
  name                 = split("/", var.subnet_id)[10]
  resource_group_name  = split("/", var.subnet_id)[4]
  virtual_network_name = split("/", var.subnet_id)[8]
}

data "azurerm_resource_group" "resource-group" {
  name = var.resource_group_name
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_name}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
  }

  lifecycle {
    ignore_changes = [ip_configuration[0].subnet_id]
  }
}

resource "azurerm_managed_disk" "disks" {
  for_each = { for idx, disk in var.data_disks : idx => disk }

  name                 = "${var.vm_name}-disk-${each.key}"
  location             = var.location
  resource_group_name  = data.azurerm_resource_group.resource-group.name
  storage_account_type = each.value.sku
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb

  zone = var.availability_zone
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.resource-group.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_D4s_v5"
  zones                 = [var.availability_zone]

  storage_image_reference {
    publisher = var.image_reference.publisher
    offer     = var.image_reference.offer
    sku       = var.image_reference.sku
    version   = var.image_reference.version
  }

  storage_os_disk {
    name          = "${var.vm_name}-osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = 128
  }

  os_profile {
    computer_name  = substr(var.vm_name, 0, 15)
    admin_username = var.administrator_login
    admin_password = random_password.vm-password.result
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

}

resource "azurerm_virtual_machine_data_disk_attachment" "attach-data-disks" {
  for_each = azurerm_managed_disk.disks

  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_virtual_machine.vm.id
  lun                = each.key
  caching            = "ReadWrite"

}

output "vm_credentials" {
  value = {
    username = var.administrator_login
    password = random_password.vm-password.result
  }

}

