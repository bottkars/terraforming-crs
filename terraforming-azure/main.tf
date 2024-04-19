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
      version = "~> 3.1"
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


module "common_rg" {
  source              = "./modules/rg"
  count               = var.create_common_rg ? 1 : 0
  resource_group_name = var.common_resource_group_name
  location            = var.common_location
}

module "ppcr" {
  source              = "./modules/ppcr"
  count               = var.create_common_rg ? 1 : 0
}