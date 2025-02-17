variable "common_resource_group_name" {
    description = "Name of a common resource group for all but network resources"  
    default = null     
}

variable "create_common_rg" {
    type = bool
    default = true
    description = "Create a common RG"
}
variable "common_location" {
#    default = null
    description = "Name of a common resource group location for all but network resources"
}