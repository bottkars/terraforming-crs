resource "azurerm_private_endpoint" "blobendpoint" {
  name                = "${var.resourcePrefix}-privateendpoint"
  location            = data.azurerm_resource_group.ddve_resource_group.location
  resource_group_name = data.azurerm_resource_group.ddve_resource_group.name
  subnet_id           = var.management_subnet_id

  private_service_connection {
    name                           = "${var.resourcePrefix}-privateendpoint"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.ddve_atos.id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "${var.resourcePrefix}-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.ppcr-dns-zone.id]
  }
}

resource "azurerm_private_dns_zone" "ppcr-dns-zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.ddve_resource_group.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "ppcr-network-link" {
  name                  = "${var.resourcePrefix}-link"
  resource_group_name   = data.azurerm_resource_group.ddve_resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.ppcr-dns-zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "blobservice" {
  name                = "crsprivatelink.blob.core.windows.net"
  zone_name           = "crsprivatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.ddve_resource_group.name
  ttl                 = "10"
  records             = [ azurerm_private_endpoint.blobendpoint.private_service_connection[0].private_ip_address ]
}


output "privatelink" {
  value = azurerm_private_endpoint.blobendpoint.private_service_connection[0].private_ip_address
}
