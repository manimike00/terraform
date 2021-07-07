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
  depends_on      = [module.rg]
  source          = "./vnet"
  environment     = var.environment
  location        = var.location
  owner           = var.owner
  project         = var.project
  rg              = module.rg.rg
  public_subnets  = 4
  private_subnets = 2
}

# VM Module
module "bastion" {
  depends_on  = [module.vnet]
  source      = "./vm"
  environment = "bastion" #var.environment
  location    = var.location
  owner       = var.owner
  project     = var.project
  rg          = module.rg.rg
  subnet_id   = module.vnet.public-subnet-id[0]
  hostname    = var.hostname
  username    = var.username
  password    = var.password
  type        = "public"
}

# VM Module
module "dmoapp" {
  depends_on  = [module.bastion]
  source      = "./vm"
  environment = "dmoapp" #var.environment
  location    = var.location
  owner       = var.owner
  project     = var.project
  rg          = module.rg.rg
  subnet_id   = module.vnet.private-subnet-id[0]
  hostname    = var.hostname
  username    = var.username
  password    = var.password
  type        = "private"
}