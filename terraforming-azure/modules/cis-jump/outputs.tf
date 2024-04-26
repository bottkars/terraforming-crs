output "jumphost_private_ip_address" {
  value = azurerm_network_interface.jumphost_nic.private_ip_address
}