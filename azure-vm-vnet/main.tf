# Provides configuration details for terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Resource Group Module
module "rg" {
  source      = "./rg"
  environment = "dev"
  location    = "centralindia"
  owner       = "rapyder"
  project     = "perfios"
}

# Vnet Module
module "vnet" {
  source      = "./vnet"
  environment = "dev"
  location    = "centralindia"
  owner       = "rapyder"
  project     = "perfios"
  rg          = module.rg.rg
}

# VM Module
module "vm" {
  source               = "./vm"
  environment          = "dev"
  location             = "centralindia"
  owner                = "rapyder"
  project              = "perfios"
  rg                   = module.rg.rg
  subnet_id            = module.vnet.public-subnet-id
  hostname             = "rapyder.com"
  username             = "rapyder"
  password             = "azurerapyder@123"
  public_ip_address_id = module.vnet.public-ip-prefix-id
}