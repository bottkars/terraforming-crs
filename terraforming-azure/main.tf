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
  Subnet0AddressSpace           = var.JumpHostSubnetAddressSpace
  Subnet1AddressSpace           = var.CR_DDVE_SubnetAddressSpace
}



module "common_rg" {
  source              = "./modules/rg"
  count               = var.create_common_rg ? 1 : 0
  resource_group_name = var.common_resource_group_name == "" ? "${var.resourcePrefix}-rg" : var.common_resource_group_name
  location            = var.common_location
}

module "ppcr" {
  source                       = "./modules/ppcr"
  networks_resource_group_name = var.ppcr_networks_resource_group_name
  CR_DDVE_subnet_id = var.create_networks ? module.networks[0].subnet_0_id : var.CR_DDVE_subnet_id
  resource_group_name          = var.create_common_rg ? module.common_rg[0].resource_group.name : var.ppcr_resource_group_name
  resourcePrefix               = var.resourcePrefix
  PPCR_MgmtIpAddress           = cidrhost(var.CR_DDVE_SubnetAddressSpace, var.PPCR_MgmtNumber)
}
