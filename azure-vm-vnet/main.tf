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
  environment = var.environment
  location    = var.location
  owner       = var.owner
  project     = var.project
}

# Vnet Module
module "vnet" {
  source      = "./vnet"
  environment = var.environment
  location    = var.location
  owner       = var.owner
  project     = var.project
  rg          = module.rg.rg
}

# VM Module
module "vm" {
  source      = "./vm"
  environment = var.environment
  location    = var.location
  owner       = var.owner
  project     = var.project
  rg          = module.rg.rg
  subnet_id   = module.vnet.public-subnet-id
  hostname    = var.hostname
  username    = var.username
  password    = var.password
}