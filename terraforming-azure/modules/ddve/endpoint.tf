resource "azurerm_private_endpoint" "blobendpoint" {
  name                = "${var.resourcePrefix}-privateendpoint"
  location            = data.azurerm_resource_group.ddve_networks_resource_group.location
  resource_group_name = data.azurerm_resource_group.ddve_networks_resource_group.name
  subnet_id           = var.management_subnet_id

  private_service_connection {
    name                           = "${var.resourcePrefix}-privateendpoint"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.ddve_atos.id
    subresource_names              = ["blob"]
  }

}

