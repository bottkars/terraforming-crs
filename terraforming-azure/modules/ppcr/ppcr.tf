locals {
  MgmtHostVirtualMachineSize = "Standard_D4ds_v4"
}
data "azurerm_resource_group" "ppcr_networks_resource_group" {
  name = var.networks_resource_group_name
}
data "azurerm_resource_group" "ppcr_resource_group" {
  name = var.resource_group_name
}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloudinit.tpl")

}

resource "tls_private_key" "ppcr" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "random_string" "storage_account_name" {
  length  = 16
  special = false
  upper   = false
}


resource "azurerm_virtual_machine" "ppcr" {
  name                             = "${var.resourcePrefix}-CR-VM"
  resource_group_name              = data.azurerm_resource_group.ppcr_resource_group.name
  location                         = data.azurerm_resource_group.ppcr_resource_group.location
  depends_on                       = [azurerm_network_interface.ppcr_nic, azurerm_storage_account.ppcr_diag_storage_account]
  network_interface_ids            = [azurerm_network_interface.ppcr_nic.id]
  vm_size                          = local.MgmtHostVirtualMachineSize
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"

  storage_os_disk {
    name              = "${var.resourcePrefix}-ppcrOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  storage_image_reference {
    #    id = local.ppcr_image[var.ppcr_version]["id"]
    id = "/subscriptions/2763ec59-6bb9-45bd-a62c-468bd0177ba2/resourceGroups/cr_general_rg/providers/Microsoft.Compute/galleries/cr_general_gallary/images/cyber_recovery_mgmnt_host/versions/19.16.01"
  }
  os_profile {
    computer_name  = "${var.resourcePrefix}-CR-VM"
    admin_username = var.MgmtHostAdminUsername
    admin_password = var.MgmtHostAdminPassword
    custom_data    = base64encode(data.template_file.cloudinit.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ppcr.public_key_openssh
      path     = "/home/${var.MgmtHostAdminUsername}/.ssh/authorized_keys"

    }

  }
  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.ppcr_diag_storage_account.primary_blob_endpoint
  }
  zones = ["1"]
  tags = {
    "cr.vault-mgmt-host.account" : "PPCR Mgmt Host VM"
  }
}

resource "azurerm_network_interface" "ppcr_nic" {
  name                = "${var.resourcePrefix}-CR-VM-nic"
  resource_group_name = data.azurerm_resource_group.ppcr_networks_resource_group.name
  location            = data.azurerm_resource_group.ppcr_networks_resource_group.location
  ip_configuration {
    name                          = "${var.resourcePrefix}-CR-VM-ip-config"
    subnet_id                     = var.CR_DDVE_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.PPCR_MgmtIpAddress
    private_ip_address_version    = "IPv4"
  }
}


resource "azurerm_storage_account" "ppcr_diag_storage_account" {
  name                     = "vmdiag${random_string.storage_account_name.result}"
  resource_group_name              = data.azurerm_resource_group.ppcr_resource_group.name
  location                         = data.azurerm_resource_group.ppcr_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_2"
  enable_https_traffic_only = true
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.CR_DDVE_subnet_id]
  }
  tags = {
    vm = "${var.resourcePrefix}-CR-VM"
  }
}

resource "azurerm_role_assignment" "ppcr_role" {
  scope                = data.azurerm_resource_group.ppcr_resource_group.id 
  role_definition_name = "Contributor"
  principal_id         = azurerm_virtual_machine.ppcr.identity[0].principal_id
}