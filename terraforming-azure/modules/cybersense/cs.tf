locals {
  MgmtHostVirtualMachineSize = "Standard_D16s_v3"
}
data "azurerm_resource_group" "cs_networks_resource_group" {
  name = var.networks_resource_group_name
}
data "azurerm_resource_group" "cs_resource_group" {
  name = var.resource_group_name
}

#data "template_file" "cloudinit" {
#  template = file("${path.module}/cloudinit.tpl")
#
#}

resource "tls_private_key" "cs" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "random_string" "storage_account_name" {
  length  = 16
  special = false
  upper   = false
}


resource "azurerm_virtual_machine" "cs" {
  name                             = "${var.resourcePrefix}-CS-VM"
  resource_group_name              = data.azurerm_resource_group.cs_resource_group.name
  location                         = data.azurerm_resource_group.cs_resource_group.location
  depends_on                       = [azurerm_network_interface.cs_nic, azurerm_storage_account.cs_diag_storage_account]
  network_interface_ids            = [azurerm_network_interface.cs_nic.id]
  vm_size                          = local.MgmtHostVirtualMachineSize
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"

  storage_os_disk {
    name              = "${var.resourcePrefix}-csOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }
  storage_image_reference {
    id = var.CS_Image_Id
  }
  os_profile {
    computer_name  = "${var.resourcePrefix}-CS-VM"
    admin_username = var.MgmtHostAdminUsername
    admin_password = var.MgmtHostAdminPassword
    custom_data    = base64encode(data.template_file.cloudinit.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.cs.public_key_openssh
      path     = "/home/${var.MgmtHostAdminUsername}/.ssh/authorized_keys"

    }

  }
  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.cs_diag_storage_account.primary_blob_endpoint
  }
  zones = ["1"]
  tags = merge(
    var.customTags,
    {
      "cr.cs-host.account" : "CS Host VM"
    }
  )
}

resource "azurerm_network_interface" "cs_nic" {
  name                = "${var.resourcePrefix}-CS-VM-nic"
  resource_group_name = data.azurerm_resource_group.cs_networks_resource_group.name
  location            = data.azurerm_resource_group.cs_networks_resource_group.location
  ip_configuration {
    name                          = "${var.resourcePrefix}-CS-VM-ip-config"
    subnet_id                     = var.CR_DDVE_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.CS_IpAddress
    private_ip_address_version    = "IPv4"
  }
}


resource "azurerm_storage_account" "cs_diag_storage_account" {
  name                      = "vmdiag${random_string.storage_account_name.result}"
  resource_group_name       = data.azurerm_resource_group.cs_resource_group.name
  location                  = data.azurerm_resource_group.cs_resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [var.CR_DDVE_subnet_id]
  }
  tags = merge(
    var.customTags,
    {
      vm = "${var.resourcePrefix}-CS-VM"
    }
  )
}

resource "azurerm_role_assignment" "cs_role" {
  scope                = data.azurerm_resource_group.cs_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_virtual_machine.cs.identity[0].principal_id
}
