variable "MgmtHostAdminPassword" {
  default = "Password123!"
}
variable "MgmtHostAdminUsername" {
  default = "azureuser"
}
variable "resourcePrefix" {
}

variable "CR_DDVE_subnet_id" {  
}
variable "PPCR_MgmtIpAddress" {
}
variable "CS_IpAddress" {
}
variable "jumphostIpAddress" {
}
variable "networks_resource_group_name" {
}
variable "privatelinkip" {
}
variable "resource_group_name" {
}

variable "DataDomainMgmtIpAddress" {
  
}
variable "customTags" {
  default = {}
}
variable "CS_Image_Id" {
  default = null
}