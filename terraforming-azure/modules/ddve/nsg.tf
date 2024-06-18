resource "azurerm_network_security_group" "ddve_security_group" {
  name                = "${var.resourcePrefix}-dd-nsg"
  location            = data.azurerm_resource_group.ddve_resource_group.location
  resource_group_name = data.azurerm_resource_group.ddve_resource_group.name

  security_rule {
    name              = "Allow_Mgmt_Host_to_DDVE_In"
    priority          = 200
    direction         = "Inbound"
    access            = "Allow"
    description       = "Allow SSH and NFS to DDVE from Mgmt Host"
    protocol          = "TCP"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "111",
      "2049",
      "2052",
      "3009"
    ]
    source_address_prefix      = var.PPCR_MgmtIpAddress
    destination_address_prefix = var.DataDomainMgmtIpAddress
  }

  security_rule {
    name                       = "Allow_Jump_Host_to_DDVE_HTTPS_In"
    priority                   = 210
    direction                  = "Inbound"
    access                     = "Allow"
    description                = "Allow HTTPS to DDVE from Jump Host"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    source_address_prefix      = var.jumphostIpAddress
    destination_address_prefix = var.DataDomainMgmtIpAddress
  }

  security_rule {
    name              = "Allow_DDVE_to_Mgmt_Host_Out"
    priority          = 200
    direction         = "Outbound"
    access            = "Allow"
    description       = "Allow SSH and NFS to DDVE from Mgmt Host"
    protocol          = "TCP"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "111",
      "2049",
      "2052",
      "3009"
    ]
    source_address_prefix      = var.PPCR_MgmtIpAddress
    destination_address_prefix = var.DataDomainMgmtIpAddress
  }
  security_rule {
    name              = "Allow_DDVE_replication"
    priority          = 500
    direction         = "Inbound"
    access            = "Allow"
    description       = "Allow SSH and NFS to DDVE from Mgmt Host"
    protocol          = "TCP"
    source_port_range = "*"
    destination_port_ranges = [

      "2051",

    ]
    source_address_prefix      = "10.204.108.137/32"
    destination_address_prefix = var.ReplicationIpAddress
  }
  security_rule {
    name                       = "Allow_DDVE_to_Endpoint_HTTPS_Out"
    priority                   = 210
    direction                  = "Outbound"
    access                     = "Allow"
    description                = "Allow HTTPS to Endpoint from DDVE"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    source_address_prefix      = var.PPCR_MgmtIpAddress
    destination_address_prefix = azurerm_private_endpoint.blobendpoint.private_service_connection[0].private_ip_address
  }

 # security_rule {
 #   name                       = "Deny_All_Inbound"
 #   priority                   = 4096
 #   direction                  = "Inbound"
 #   access                     = "Deny"
 #   description                = "Deny All Inbound - Overrides Azure Allow All Default Rule"
 #   protocol                   = "*"
 #   source_port_range          = "*"
  #  destination_port_range     = "*"
 #   source_address_prefix      = "*"
 #   destination_address_prefix = "*"
 # }
# security_rule {
#    name                       = "Deny_All_Outbound"
#    priority                   = 4096
#    direction                  = "Outbound"
#    access                     = "Deny"
#    description                = "Deny All Outbound - Overrides Azure Allow All Default Rule"
#    protocol                   = "*"
#    source_port_range          = "*"
#    destination_port_range     = "*"
#    source_address_prefix      = "*"
#    destination_address_prefix = "*"
#  }
  tags = merge(
    var.customTags,
    {
      "cr.vault-ddve.sg" : "DDVE Interface NSG"
  })
}

resource "azurerm_network_interface_security_group_association" "jh_security_group_nic1" {
  network_interface_id      = azurerm_network_interface.ddve_nic1.id
  network_security_group_id = azurerm_network_security_group.ddve_security_group.id
}

resource "azurerm_network_interface_security_group_association" "ddve_security_group_nic2" {
  network_interface_id      = azurerm_network_interface.ddve_nic2.id
  network_security_group_id = azurerm_network_security_group.ddve_security_group.id
}


