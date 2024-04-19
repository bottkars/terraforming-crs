variable "common_resource_group_name" {
    description = "Name of a common resorce group for all but network resources"
}

variable "create_common_rg" {
    type = bool
    default = false
    description = "Create a common RG"
}
variable "common_location" {
    default = null
    description = "Name of a common resource group location for all but network resources"
}