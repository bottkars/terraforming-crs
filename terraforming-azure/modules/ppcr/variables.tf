variable "MgmtHostAdminPassword" {
  default = "Password123!"
}
variable "MgmtHostAdminUsername" {
  default = "azureuser"

}
variable "resourcePrefix" {
  default = "PPCR"
}

variable "subnet_id" {
  default = "/subscriptions/b7361191-e5f0-415b-92db-5a1b1057f6eb/resourceGroups/csc-edub-ashci-rg/providers/Microsoft.Network/virtualNetworks/ashci-vnet01/subnets/default"
}

variable "MgmtHostIpAddress" {
  default = "10.0.0.30"
}

variable "ppcr_networks_resource_group_name" {
  default = "csc-edub-ashci-rg"
}

variable "ppcr_resource_group_name" {
  default = "customer0"

}
