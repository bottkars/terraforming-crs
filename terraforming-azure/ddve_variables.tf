
variable "ddve_initial_password" {
  default     = "Change_Me12345_"
  description = "the initial Password for Datadomain. It will be exposed to output as DDVE_PASSWORD for further Configuration. \nAs DD will be confiured with SSH, the Password must be changed from changeme"
}

variable "ddve_tcp_inbound_rules_Inet" {
  type        = list(string)
  default     = ["22", "443"]
  description = "inbound Traffic rule for Security Group from Internet"
}

variable "ddve_count" {
  type        = number
  default     = 0
  description = "will deploy DDVE when number greater 0. Number indicates number of DDVE Instances"
}

variable "ddve_meta_disks" {
  type    = list(string)
  default = ["1023", "1023"]
}
variable "ddve_resource_group_name" {
  description = "Bring your own resourcegroup. the Code will read the Data from the resourcegroup name specified here"
  type        = string
  default     = null
}

variable "ddve_networks_resource_group_name" {
  description = "Bring your own Network resourcegroup. the Code will read the Data from the resourcegroup name specified here"
  type        = string
  default     = null
}
variable "ddve_ReplNumber" {
  default = 9
}

variable "ddve_MgmtNumber"    {
  default = 4
}

variable "ddvelist" {
  default = [
    {
      "ddve_meta_disks" = [1000, 1000],
      "ddve_type"       = "16 TB DDVE"
      "ddve_version"    = "7.13.0020.MSDN"
    },
    {
      "ddve_meta_disks" : [1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000],
      "ddve_type" : "96 TB DDVE"
            "ddve_version"    = "7.13.020"
    },
    {
      "ddve_meta_disks" : [1000, 1000, 1000, 1000],
      "ddve_type" : "32 TB DDVE"
    },
    {
      "ddve_meta_disks" : [2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000],
      "ddve_type" : "256 TB DDVE"
    }
  ]
}
variable "ddve_version" {
  type        = string
  default     = "7.13.020"
  description = "DDVE Version, can be: '7.7.525', '7.10.115', '7.10.120', '7.13.020', '7.10.1015.MSDN', '7.10.120.MSDN', '7.7.5020.MSDN', '7.13.0020.MSDN'"
  validation {
    condition = anytrue([
      var.ddve_version == "7.7.525",
      var.ddve_version == "7.10.115",
      var.ddve_version == "7.10.120",
      var.ddve_version == "7.13.020",
      var.ddve_version == "7.10.1015.MSDN",
      var.ddve_version == "7.10.120.MSDN",
      var.ddve_version == "7.7.5020.MSDN",
      var.ddve_version == "7.13.0020.MSDN",
    ])
    error_message = "Must be a valid DDVE Version, can be:  '7.7.525', '7.10.115', '7.10.120', '7.13.020', '7.10.1015.MSDN', '7.10.120.MSDN', '7.7.5020.MSDN', '7.13.0020.MSDN' ."
  }
}


variable "ddve_type" {
  type        = string
  default     = "16 TB DDVE"
  description = "DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE','16 TB DDVE PERF', '32 TB DDVE PERF', '96 TB DDVE PERF', '256 TB DDVE PERF'"
  validation {
    condition = anytrue([
      var.ddve_type == "16 TB DDVE",
      var.ddve_type == "32 TB DDVE",
      var.ddve_type == "96 TB DDVE",
      var.ddve_type == "256 TB DDVE",
      var.ddve_type == "16 TB DDVE PERF",
      var.ddve_type == "32 TB DDVE PERF",
      var.ddve_type == "96 TB DDVE PERF",
      var.ddve_type == "256 TB DDVE PERF"
    ])
    error_message = "Must be a valid DDVE Type, can be: '16 TB DDVE', '32 TB DDVE', '96 TB DDVE', '256 TB DDVE'."
  }
}

variable "vnet_id" {
  default = ""
}