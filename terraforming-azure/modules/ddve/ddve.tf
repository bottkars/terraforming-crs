locals {
  ddve_size = {
    "16 TB DDVE" = {
      instance_type  = "Standard_D4ds_v5"
      ddve_disk_type = "Standard_LRS"
    }
    "32 TB DDVE" = {
      instance_type  = "Standard_D8ds_v4"
      ddve_disk_type = "Standard_LRS"
    }
    "96 TB DDVE" = {
      instance_type  = "Standard_D16ds_v4"
      ddve_disk_type = "Standard_LRS"
    }
    "256 TB DDVE" = {
      instance_type  = "Standard_D32ds_v4"
      ddve_disk_type = "Standard_LRS"
    }
    "16 TB DDVE PERF" = {
      instance_type  = "Standard_D4ds_v5"
      ddve_disk_type = "Premium_LRS"
    }
    "32 TB DDVE PERF" = {
      instance_type  = "Standard_D8ds_v4"
      ddve_disk_type = "Premium_LRS"
    }
    "96 TB DDVE PERF" = {
      instance_type  = "Standard_D16ds_v4"
      ddve_disk_type = "Premium_LRS"
    }
    "256 TB DDVE PERF" = {
      instance_type  = "Standard_D32ds_v4"
      ddve_disk_type = "Premium_LRS"
    }
  }
  ddve_image = {

  #  'MSN Deployable'
    "7.10.1030.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-710115"
      version   = "7.10.1030"
    }
    "7.10.1040.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-710115"
      version   = "7.10.1040"
    } 
    "7.10.1050.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-710115"
      version   = "7.10.1050"
    }       
    "7.13.100.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-713"
      version   = "7.13.100"
    }
    "7.13.1010.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-713"
      version   = "7.13.1010"
    }
    "7.7.5040.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-77525"
      version   = "7.7.5040"
    }
    "7.7.5050.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-77525"
      version   = "7.7.5050"
    }    
    "8.1.0010.MSDN" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve-81"
      version   = "8.1.0010"
    }  

    # Branded Image SKU´s


    "7.10.1030" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.10.1030"
    }
    "7.10.1040" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.10.1040"
    }
    "7.10.1050" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.10.1050"
    } 
    "7.13.100" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.13.100"
    }
    "7.13.1010" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.13.020"
    }       
    "7.7.5040" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.7.5040"
    }
    "7.7.5050" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "7.7.5050"
    }
    "8.1.000" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "8.1.000"
    }
    "8.1.0010" = {
      publisher = "dellemc"
      offer     = "dell-emc-datadomain-virtual-edition-v4"
      sku       = "ddve"
      version   = "8.1.0010"
    }    
  }

}
data "azurerm_resource_group" "ddve_networks_resource_group" {
  name = var.ddve_networks_resource_group_name
}

data "azurerm_resource_group" "ddve_resource_group" {
  name = var.ddve_resource_group_name
}


data "http" "myip" {
  url = "https://v4.ident.me"
}


resource "azurerm_role_assignment" "objectstore" {
  scope                = azurerm_storage_account.ddve_atos.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_virtual_machine.ddve.identity[0].principal_id
}

resource "random_string" "storage_account_name" {
  length  = 10
  special = false
  upper   = false
}

resource "tls_private_key" "ddve" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "random_string" "fqdn_name" {
  length  = 8
  special = false
  upper   = false
}
resource "azurerm_storage_account" "ddve_diag_storage_account" {
  name                      = "${var.ddve_instance}diag${random_string.storage_account_name.result}"
  resource_group_name       = data.azurerm_resource_group.ddve_resource_group.name
  location                  = data.azurerm_resource_group.ddve_resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  network_rules {
    default_action             = "Deny"
    ip_rules                   = [chomp(data.http.myip.response_body)]
    virtual_network_subnet_ids = [var.management_subnet_id]
  }
    tags = merge(
    var.customTags,
     {
    environment = var.deployment
    autodelete  = var.autodelete
  })
}

resource "azurerm_storage_account" "ddve_atos" {
  name                      = "${var.ddve_instance}atos${random_string.storage_account_name.result}"
  resource_group_name       = data.azurerm_resource_group.ddve_resource_group.name
  location                  = data.azurerm_resource_group.ddve_resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  network_rules {
    default_action             = "Deny"
    ip_rules                   = [chomp(data.http.myip.response_body)]
    virtual_network_subnet_ids = [var.management_subnet_id]
  }
    tags = merge(
    var.customTags,
     {
    "cr.vault-storage.account" : "PPCR Storage Account"
  })
}

resource "azurerm_storage_container" "atos" {
  name                  = "object"
  storage_account_name  = azurerm_storage_account.ddve_atos.name
  container_access_type = "private"
#  depends_on = [ azurerm_private_endpoint.blobendpoint ]
}




resource "azurerm_marketplace_agreement" "ddve" {
  publisher = local.ddve_image[var.ddve_version]["publisher"]
  offer     = local.ddve_image[var.ddve_version]["offer"]
  plan      = local.ddve_image[var.ddve_version]["sku"] 
}
# DNS


## dynamic NSG

# VMs
## network interface
resource "azurerm_network_interface" "ddve_nic1" {
  name                = "${var.resourcePrefix}-${var.ddve_instance}-nic1"
  location            = data.azurerm_resource_group.ddve_networks_resource_group.location
  resource_group_name = data.azurerm_resource_group.ddve_networks_resource_group.name
  ip_configuration {
    primary                       = "true"
    name                          = "${var.resourcePrefix}-${var.ddve_instance}-ip-config"
    subnet_id                     = var.management_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.DataDomainMgmtIpAddress
    private_ip_address_version    = "IPv4"
  }
}
resource "azurerm_network_interface" "ddve_nic2" {
  name                = "${var.resourcePrefix}-${var.ddve_instance}-nic2"
  location            = data.azurerm_resource_group.ddve_networks_resource_group.location
  resource_group_name = data.azurerm_resource_group.ddve_networks_resource_group.name
  ip_configuration {
    name                          = "${var.resourcePrefix}-${var.ddve_instance}-ip-config1"
    subnet_id                     = var.replication_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ReplicationIpAddress
    private_ip_address_version    = "IPv4"
  }
}

resource "azurerm_virtual_machine" "ddve" {
  name                             = "${var.resourcePrefix}-${var.ddve_instance}"
  location                         = data.azurerm_resource_group.ddve_resource_group.location
  resource_group_name              = data.azurerm_resource_group.ddve_resource_group.name
  depends_on                       = [azurerm_network_interface.ddve_nic1, azurerm_network_interface.ddve_nic2] #, azurerm_network_interface_security_group_association.ddve_security_group_nic1, azurerm_network_interface_security_group_association.ddve_security_group_nic2]
  network_interface_ids            = [azurerm_network_interface.ddve_nic1.id, azurerm_network_interface.ddve_nic2.id]
  primary_network_interface_id     = azurerm_network_interface.ddve_nic1.id
  vm_size                          = local.ddve_size[var.ddve_type].instance_type
  delete_os_disk_on_termination    = "true"
  delete_data_disks_on_termination = "true"
  storage_os_disk {
    name              = "${var.ddve_instance}-DDVEOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = local.ddve_size[var.ddve_type].ddve_disk_type
  }
  storage_data_disk {
    name              = "${var.ddve_instance}-nvr-disk"
    disk_size_gb      = "10"
    create_option     = "FromImage"
    managed_disk_type = local.ddve_size[var.ddve_type].ddve_disk_type
    lun               = "0"
  }

  dynamic "storage_data_disk" {
    for_each = var.ddve_meta_disks
    content {
      name              = "${var.ddve_instance}-Metadata-${storage_data_disk.key + 1}"
      lun               = storage_data_disk.key + 1
      disk_size_gb      = storage_data_disk.value
      create_option     = "empty"
      managed_disk_type = local.ddve_size[var.ddve_type].ddve_disk_type
    }
  }

  plan {
    publisher = local.ddve_image[var.ddve_version]["publisher"]
    product   = local.ddve_image[var.ddve_version]["offer"]
    name      = local.ddve_image[var.ddve_version]["sku"]

  }

  storage_image_reference {
    publisher = local.ddve_image[var.ddve_version]["publisher"]
    offer     = local.ddve_image[var.ddve_version]["offer"]
    sku       = local.ddve_image[var.ddve_version]["sku"]
    version   = local.ddve_image[var.ddve_version]["version"]
  }
  os_profile {
    computer_name  = var.ddve_instance
    admin_username = "sysadmin"
    admin_password = var.ddve_password
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ddve.public_key_openssh
      path     = "/home/sysadmin/.ssh/authorized_keys"
    }
  }
  identity {
    type = "SystemAssigned"
    #    identity_ids = [azurerm_user_assigned_identity.storage.id]
  }
  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.ddve_diag_storage_account.primary_blob_endpoint
  }

    tags = merge(
    var.customTags,
     {
    "cr.vault.-ddve.vm": "PPCR DDVE VM"
  })
}
