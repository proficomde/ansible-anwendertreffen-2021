# Initialize Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.56.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "azurerm" {

  subscription_id = <subscription id>
  client_id       = <client id>
  client_secret   = <client secret>
  tenant_id       = <tenant id>

  features {}
}

provider "local" {
  # Configuration options
}