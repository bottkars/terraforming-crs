
#data "azurerm_resource_group" "networks_resource_group" {
#  name = var.networks_resource_group_name
#}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.resourcePrefix}-vnet"
  resource_group_name = var.networks_resource_group_name
  address_space       = var.virtual_network_address_space
  location            = var.location
    tags = merge(
    var.customTags,
    {

    }
  )
}

resource "azurerm_subnet" "subnet_0" {
  name                 = "${var.resourcePrefix}-jh-subnet"
  resource_group_name = var.networks_resource_group_name
  virtual_network_name = "${var.resourcePrefix}-vnet"
  address_prefixes     = var.Subnet0AddressSpace
  depends_on = [ azurerm_virtual_network.virtual_network ]
}


resource "azurerm_subnet" "subnet_1" {
  name                 = "${var.resourcePrefix}-crddve-subnet"
  resource_group_name = var.networks_resource_group_name
  virtual_network_name = "${var.resourcePrefix}-vnet"
  address_prefixes     = var.Subnet1AddressSpace
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
  depends_on = [ azurerm_virtual_network.virtual_network ]
}