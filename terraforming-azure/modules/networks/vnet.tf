
data "azurerm_resource_group" "ppcr_networks_resource_group" {
  name = var.networks_resource_group_name
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.resourcePrefix}-vnet"
  depends_on          = [azurerm_resource_group.resource_group]
  resource_group_name = data.networks_resource_group.name
  address_space       = var.virtual_network_address_space
  location            = var.location
}