resource "azurerm_network_security_group" "jh_security_group" {
  name                = "${var.resourcePrefix}-jh-nsg"
  resource_group_name = data.azurerm_resource_group.jumphost_resource_group.name
  location            = data.azurerm_resource_group.jumphost_resource_group.location

  security_rule {
    name                       = "Allow_RDP_to_Jump_Host_In"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    description                = "allow RDP access"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["3389"]
    source_address_prefix      = var.ProductionClientIpAddress
    destination_address_prefix = var.jumphostIpAddress
  }

  security_rule {
    name                       = "Allow_Jump_Host_to_DDVE_HTTPS_Out"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    description                = "Allow HTTPS to DDVE from Jump Host"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["443"]
    source_address_prefix      = var.jumphostIpAddress
    destination_address_prefix = var.DataDomainMgmtIpAddress
  }

  security_rule {
    name              = "Allow_Jump_Host_to_Mgmt_Host_Traffic_Out"
    priority          = 210
    direction         = "Outbound"
    access            = "Allow"
    description       = "Allow SSH, REST, Ngninx to Mgmt Host from Jump Host"
    protocol          = "TCP"
    source_port_range = "*"
    destination_port_ranges = [
      "22",
      "14777",
      "14778",
      "14780"
    ]
    source_address_prefix      = var.jumphostIpAddress
    destination_address_prefix = var.PPCR_MgmtIpAddress
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
      "cr.vault-jump-host.sg" : "PPCR Jump Host NSG"
  })
}

resource "azurerm_network_interface_security_group_association" "jh_security_group_nic1" {
  network_interface_id      = azurerm_network_interface.jumphost_nic.id
  network_security_group_id = azurerm_network_security_group.jh_security_group.id
}
