
locals {
  jumphostVirtualMachineSize = "Standard_D2_v3"
}
data "azurerm_resource_group" "jumphost_networks_resource_group" {
  name = var.networks_resource_group_name
}
data "azurerm_resource_group" "jumphost_resource_group" {
  name = var.resource_group_name
}

resource "random_string" "storage_account_name" {
  length  = 10
  special = false
  upper   = false
}



resource "azurerm_virtual_machine" "jumphost" {
  name                          = "${var.resourcePrefix}-JH-VM"
  resource_group_name           = data.azurerm_resource_group.jumphost_resource_group.name
  location                      = data.azurerm_resource_group.jumphost_resource_group.location
  depends_on                    = [azurerm_network_interface.jumphost_nic, azurerm_storage_account.jumphost_diag_storage_account]
  network_interface_ids         = [azurerm_network_interface.jumphost_nic.id]
  vm_size                       = local.jumphostVirtualMachineSize
  delete_os_disk_on_termination = "true"
  storage_os_disk {
    name              = "JHOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  os_profile {
    computer_name  = "${var.resourcePrefix}-JH-VM"
    admin_username = var.jumphostAdminUserName
    admin_password = var.jumphostAdminPassword
  }
  os_profile_windows_config {
    enable_automatic_upgrades = false
  }



  plan {
    publisher = "MicrosoftWindowsServer"
    product   = "WindowsServer"
    name      = "2019-datacenter-gensecond"

  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-datacenter-gensecond"
    version   = "latest"
  }
  # plan {
  #   publisher = "center-for-internet-security-inc"
  #   product   = "cis-windows-server"
  #   name      = "cis-windows-server2019-l2-gen1"

  # }

  # storage_image_reference {
  #   publisher = "center-for-internet-security-inc"
  #   offer     = "cis-windows-server"
  #   sku       = "cis-windows-server2019-l2-gen1"
  #   version   = "latest"
  # }
  zones = ["1"]
  tags = merge(
    var.customTags,
    {
      "cr.vault-jump-host.vm" : "PPCR Jump Host VM"
    }
  )
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.jumphost_diag_storage_account.primary_blob_endpoint
  }

}


resource "azurerm_network_interface" "jumphost_nic" {
  name                = "${var.resourcePrefix}-jumpHost-VM-nic"
  resource_group_name = data.azurerm_resource_group.jumphost_networks_resource_group.name
  location            = data.azurerm_resource_group.jumphost_networks_resource_group.location
  ip_configuration {
    name                          = "${var.resourcePrefix}-jumpHost-ip-config"
    subnet_id                     = var.jumphost_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.jumphostIpAddress
    private_ip_address_version    = "IPv4"
  }
}


resource "azurerm_storage_account" "jumphost_diag_storage_account" {
  name                      = "vmdiag${random_string.storage_account_name.result}"
  resource_group_name       = data.azurerm_resource_group.jumphost_resource_group.name
  location                  = data.azurerm_resource_group.jumphost_resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.jumphost_subnet_id]
  }
  tags = merge(
    var.customTags,
    {
      vm = "${var.resourcePrefix}-JH-VM"
      "cr.vault-jump-host.vm" : "PPCR Jump Host VM"
  })
}
