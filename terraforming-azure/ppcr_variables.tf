variable "ppcr_networks_resource_group_name" {
  default = "csc-edub-ashci-rg"
}

variable "ppcr_resource_group_name" {
  default = null
}

variable "PPCR_MgmtNumber" {
  default = 16
}

variable "PPCR_Image_Id" {
  default = "/subscriptions/2763ec59-6bb9-45bd-a62c-468bd0177ba2/resourceGroups/cr_general_rg/providers/Microsoft.Compute/galleries/cr_general_gallary/images/cyber_recovery_mgmnt_host/versions/19.16.02"
}