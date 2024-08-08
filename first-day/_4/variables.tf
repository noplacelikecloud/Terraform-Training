
variable "virutal_machine_name" {
    type    = string
    description = "The name of the virtual machine."
}

variable "resource_group_name" {
    type    = string
    default = "first-day-rg"

    validation {
        condition     = length(var.resource_group_name) > 0
        error_message = "The resource group name must not be empty."
    }

    description = "The name of the resource group."
}