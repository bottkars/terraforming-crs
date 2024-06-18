resource "azurerm_network_security_group" "cs_security_group" {
  name                = "${var.resourcePrefix}-cs-nsg"
  resource_group_name = data.azurerm_resource_group.cs_resource_group.name
  location            = data.azurerm_resource_group.cs_resource_group.location

  security_rule {
    name                       = "Allow_DDVE_to_CS_Host_In"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    description                = "Allow SSH and NFS Mount to DDVE from CS Host"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "2049", "2052", "3009", "443"]
    source_address_prefix      = var.DataDomainMgmtIpAddress
    destination_address_prefix = var.CS_IpAddress
  }


  security_rule {
    name                       = "Allow_Jump_Host_to_CS_Host_Traffic_In"
    priority                   = 220
    direction                  = "Inbound"
    access                     = "Allow"
    description                = "Allow SSH, REST, Ngninx to Mgmt Host from Jump Host"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "443", ]
    source_address_prefix      = var.jumphostIpAddress
    destination_address_prefix = var.CS_IpAddress
  }

  security_rule {
    name                       = "Allow_CS_Host_to_DDVE_Out"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    description                = "Allow SSH and NFS Mount to DDVE from Mgmt Host"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["111", "2049", "2052", "3009"]
    source_address_prefix      = var.CS_IpAddress
    destination_address_prefix = var.DataDomainMgmtIpAddress
  }
  
  security_rule {
    name                       = "Allow_CS_Host_to_AzureMgmt_HTTPS_Out"
    priority                   = 220
    direction                  = "Outbound"
    access                     = "Allow"
    description                = "Allow HTTPS to Azure Resource Management from Mgmt Host"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    source_address_prefix      = var.CS_IpAddress
    destination_address_prefix = "AzureResourceManager"
  }

  security_rule {
    name                       = "Deny_All_Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    description                = "Deny All Inbound - Overrides Azure Allow All Default Rule"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "Deny_All_Outbound"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    description                = "Deny All Outbound - Overrides Azure Allow All Default Rule"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
      tags = merge(
    var.customTags,
     {
    "cr.private-subnet2.sg" = "Private Subnet 2 NSG"
  })
}

resource "azurerm_network_interface_security_group_association" "cs_security_group_nic1" {
  network_interface_id      = azurerm_network_interface.cs_nic.id
  network_security_group_id = azurerm_network_security_group.cs_security_group.id
}
