variable "jumphost_networks_resource_group_name" {
  default = "csc-edub-ashci-rg"
}

variable "jumphost_resource_group_name" {
  default = null
}

variable "jumpHost_MgmtNumber" {
  default = 10
}
variable "ProductionClientIpAddress" {
  description = "Input the IP address to for the Production Clients that will access the Jump Host Ex. 10.0.0.30"
}