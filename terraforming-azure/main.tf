terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.94"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~>2.2.0"
    }
  }
  required_version = ">= 0.15.0"
}


provider "azurerm" {
  # The "feature" block is required for AzureRM provider 2.x.
  # If you're using version 1.x, the "features" block is not allowed.
  features {}

  # expect to use with env vars, otherwise derive from vars  ...
  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  client_secret              = var.client_secret
  tenant_id                  = var.tenant_id
  environment                = var.azure_environment
  skip_provider_registration = true
}

module "networks" {
  source                        = "./modules/networks"
  count                         = var.create_networks ? 1 : 0
  resourcePrefix                = var.resourcePrefix
  networks_resource_group_name  = var.ppcr_networks_resource_group_name
  virtual_network_address_space = var.vnetAddressSpace
  location                      = var.location
  Subnet0AddressSpace           = var.JumpHost_SubnetAddressSpace
  Subnet1AddressSpace           = var.CR_DDVE_SubnetAddressSpace
}

module "common_rg" {
  source              = "./modules/rg"
  count               = var.create_common_rg ? 1 : 0
  resource_group_name = var.common_resource_group_name == null ? "${var.resourcePrefix}-rg" : var.common_resource_group_name
  location            = var.common_location
}

module "ppcr" {
  source                       = "./modules/ppcr"
  depends_on                   = [module.common_rg]
  networks_resource_group_name = var.ppcr_networks_resource_group_name
  CR_DDVE_subnet_id            = var.create_networks ? module.networks[0].subnet_0_id : var.CR_DDVE_subnet_id
  resource_group_name          = var.create_common_rg ? module.common_rg[0].resource_group_name : var.ppcr_resource_group_name
  resourcePrefix               = var.resourcePrefix
  PPCR_MgmtIpAddress           = cidrhost(var.CR_DDVE_SubnetAddressSpace, var.PPCR_MgmtNumber)
  jumphostIpAddress            = cidrhost(var.JumpHost_SubnetAddressSpace, var.jumpHost_MgmtNumber)
  DataDomainMgmtIpAddress      = cidrhost(var.CR_DDVE_SubnetAddressSpace, var.ddve_MgmtNumber)
}


module "jumphost" {
  source                       = "./modules/cis-jump"
  depends_on                   = [module.common_rg]
  networks_resource_group_name = var.ppcr_networks_resource_group_name
  jumphost_subnet_id           = var.create_networks ? module.networks[0].subnet_0_id : var.JumpHost_subnet_id
  resource_group_name          = var.create_common_rg ? module.common_rg[0].resource_group_name : var.ppcr_resource_group_name
  resourcePrefix               = var.resourcePrefix
  jumphostIpAddress            = cidrhost(var.JumpHost_SubnetAddressSpace, var.jumpHost_MgmtNumber)
  ProductionClientIpAddress    = var.ProductionClientIpAddress
  DataDomainMgmtIpAddress      = cidrhost(var.CR_DDVE_SubnetAddressSpace, var.ddve_MgmtNumber)
  PPCR_MgmtIpAddress           = cidrhost(var.CR_DDVE_SubnetAddressSpace, var.PPCR_MgmtNumber)
}


module "ddve" {
  source                            = "./modules/ddve"
  count                             = var.ddve_count > 0 ? var.ddve_count : 0
  ddve_instance                     = count.index + 1
  depends_on                        = [module.networks, module.common_rg]
  ddve_type                         = var.ddvelist[count.index].ddve_type
  ddve_version                      = var.ddvelist[count.index].ddve_version
  ddve_meta_disks                   = var.ddvelist[count.index].ddve_meta_disks
  ddve_password                     = var.ddve_initial_password
  ddve_tcp_inbound_rules_Inet       = var.ddve_tcp_inbound_rules_Inet
  location                          = var.location
  wan_ip                            = []
  resourcePrefix                    = var.resourcePrefix
  DataDomainMgmtIpAddress           = cidrhost(var.CR_DDVE_SubnetAddressSpace, var.ddve_MgmtNumber)
  ReplicationIpAddress              = cidrhost(var.JumpHost_SubnetAddressSpace, var.ddve_ReplNumber)
  replication_subnet_id             = var.create_networks ? module.networks[0].subnet_0_id : var.JumpHost_subnet_id
  management_subnet_id              = var.create_networks ? module.networks[0].subnet_0_id : var.CR_DDVE_subnet_id
  ddve_resource_group_name          = var.create_common_rg ? module.common_rg[0].resource_group_name : var.ppcr_resource_group_name
  ddve_networks_resource_group_name = var.ppcr_networks_resource_group_name
}
