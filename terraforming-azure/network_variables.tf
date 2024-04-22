variable "create_networks" {
    type = bool
    default = false
    description = "Create Cyber Vault Networks"
}

variable "vnetAddressSpace" {
    default = "10.0.0.0/16"
}

variable "JumpHostSubnetAddressSpace" {
  default = "10.0.0.0/28"
}

variable "CR_DDVE_SubnetAddressSpace" {
  default = "10.0.0.16/28"
}

variable "CR_DDVE_subnet_id" {
  default = null
}