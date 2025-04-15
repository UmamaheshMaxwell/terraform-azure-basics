terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}
# Read and parse the JSON file
locals {
  credentials = jsondecode(file(var.credentials_file))
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = local.credentials.client_id
  client_secret   = local.credentials.client_secret
  tenant_id       = local.credentials.tenant_id
  subscription_id = local.credentials.subscription_id
}

