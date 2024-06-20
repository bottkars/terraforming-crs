resource "azurerm_network_security_group" "ddve_security_group" {
  name                = "${var.resourcePrefix}-dd-nsg"
  location            = data.azurerm_resource_group.ddve_resource_group.location
  resource_group_name = data.azurerm_resource_group.ddve_resource_group.name



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


