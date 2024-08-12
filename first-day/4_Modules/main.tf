// I'm a comment
# Me too :D

# This is a Terraform configuration file
# It's written in HashiCorp Configuration Language (HCL)


resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = local.location
}

# Now we're going to create a virtual network and a subnet
resource "azurerm_virtual_network" "vnet" {
  name                = local.virtual_network_name # Note that we're using the local value here
  resource_group_name = var.resource_group_name    # and here we're using the variable
  location            = local.location
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

data "azurerm_subnet" "vm-subnet" {                        # This is a data block. It's used to fetch data from Azure. In this case, we're fetching the subnet we just created
  name                 = "vm-subnet"                       # This is the name of the subnet
  virtual_network_name = azurerm_virtual_network.vnet.name # This is the name of the virtual network. Note that we're using the virtual network resource here to catch the name
  resource_group_name  = var.resource_group_name           # This is the name of the resource group

  depends_on = [azurerm_virtual_network.vnet] # This line specifies that this data block depends on the virtual network resource. It means that Terraform will create the virtual network first before fetching the subnet
}


# Now we're going to create a virtual machine by using a module
# Modules are a way to group together resources and configurations and make it reusable
module "vm" {
  source = "./modules/vm" # This is the path to the module. In this case, it's a local module, so we're using a relative path. There are also modules in the Terraform Registry, which you can use by specifying the path to the module in the registry
  # After the source, you can specify the input variables for the module
  resource_group_name = var.resource_group_name
  location            = local.location
  vm_name             = var.virutal_machine_name
  administrator_login = "localadmin"
  availability_zone   = 1

  subnet_id = data.azurerm_subnet.vm-subnet.id

  data_disks = []

  depends_on = [azurerm_virtual_network.vnet, data.azurerm_subnet.vm-subnet]
}

# This is an output block. It's used to define the output of the configuration
# You can use the output in other configurations or scripts
output "vm_credentials" {
  value = module.vm.vm_credentials
}