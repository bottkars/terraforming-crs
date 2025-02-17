variable "resourcePrefix" {
}

variable "autodelete" {
  default = "true"
}
variable "deployment" {
  default = "test"
}
variable "dns_subdomain" {
  default = ""
}

variable "dns_suffix" {
  default = ""
}

variable "virtual_network_address_space" {
  type    = list(any)
  default = []
}

variable "infrastructure_subnet" {
  default = ""
}
variable "ddve_resource_group_name" {

}
variable "ddve_initial_password" {
  default = "Password123!"
  
}
variable "ddve_networks_resource_group_name" {

}
#variable "resource_group_name" {
#
#}

variable "ddve_instance" {
  type = string
}


variable "ddve_password" {
  default = "Change_Me12345_"
}

variable "location" {
  default = ""
}

variable "ddve_meta_disks" {
  default = ["1000", "250", "250"]
}
variable "wan_ip" {}

variable "ddve_ppdd_nfs_client" {
  default = ""
}

variable "ddve_ppdd_nfs_path" {
  default = ""
}

variable "ddve_count" {
  type = number
}
variable "ddve_tcp_inbound_rules_Vnet" {
  default = ["22", "2049", "2051", "3009", "443"]
}
variable "ddve_tcp_inbound_rules_Inet" {
}
variable "public_ip" {
  type    = string
  default = "false"
}

variable "ReplicationIpAddress" {
  
}
variable "DataDomainMgmtIpAddress" {
  
}
variable "ProductionClientIpAddress" {

}
variable "ddve_type" {
  default = "16 TB DDVE"
}

variable "ddve_version" {
  default = "7.9.000"
}
variable "vnet_id" {
  default = ""
}
variable "management_subnet_id" {
  default = ""
}
variable "replication_subnet_id" {
  default = ""
}
variable "dns_zone_name" {
  default = ""
}
variable "jumphostIpAddress" {
}

variable "PPCR_MgmtIpAddress" {
}

variable "customTags" {
  default = {}
}