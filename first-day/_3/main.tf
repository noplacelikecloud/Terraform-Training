// I'm a comment
# Me too :D

# This is a Terraform configuration file
# It's written in HashiCorp Configuration Language (HCL)

resource "azurerm_resource_group" "rg" {
    name     = var.resource_group_name  # Here we use the variable "resource_group_name". If you use a variable in a resource block, you need to prefix it with "var."
    location = local.location           # Here we use the local value "location". If you use a local value in a resource block, you need to prefix it with "local."
}