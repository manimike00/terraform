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
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
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

module "vault" {
  depends_on  = [module.rg]
  source      = "./vault"
  environment = var.environment
  location    = var.location
  owner       = var.owner
  project     = var.project
  rg          = module.rg.rg
}

//# Virtual Machine for Bastion
//module "bastion" {
//  depends_on             = [module.vnet]
//  source                 = "./vm"
//  environment            = "bastion" #var.environment
//  location               = var.location
//  owner                  = var.owner
//  project                = var.project
//  rg                     = module.rg.rg
//  subnet_id              = module.vnet.public-subnet-id[0]
//  hostname               = var.hostname
//  username               = var.username
//  password               = var.password
//  type                   = "public"
//  vm_size                = "Standard_F2"
//  custom_data            = null
//  disk_encryption_set_id = module.vault.disk_encryption_set_id
//}


# Virtual Machine for dmoapp
data "template_file" "dmoapp" {
  depends_on = [module.vnet]
  template   = filebase64("${path.module}/dmoapp.sh")
}

module "dmoapp-vm" {
  depends_on             = [module.vnet]
  source                 = "./vm"
  environment            = "dmoapp" #var.environment
  location               = var.location
  owner                  = var.owner
  project                = var.project
  rg                     = module.rg.rg
  subnet_id              = module.vnet.private-subnet-id[0]
  hostname               = var.hostname
  username               = var.username
  password               = var.password
  custom_data            = data.template_file.dmoapp.rendered
  vm_size                = "Standard_F2"
  storage_account_type   = "Standard_LRS"
  type                   = "private"
  disk_encryption_set_id = module.vault.disk_encryption_set_id
}

module "dmoapp-disk" {
  depends_on             = [module.vnet]
  source                 = "./disk"
  environment            = "dmoapp"
  location               = var.location
  owner                  = var.owner
  project                = var.project
  rg                     = module.rg.rg
  disk_size_gb           = 50
  vm_name                = module.dmoapp-vm.vm_name
  vm_id                  = module.dmoapp-vm.vm_id
  vault_name             = module.vault.vault_name
  vault_keyname          = module.vault.vault_key_name
  vault_keyversion       = module.vault.vault_key_version
  disk_encryption_set_id = module.vault.disk_encryption_set_id
}

//module "alb" {
//  depends_on       = [module.dmoapp]
//  source           = "./loadbalancer"
//  environment      = var.environment
//  location         = var.location
//  owner            = var.owner
//  project          = var.project
//  rg               = module.rg.rg
//  public_subnet_id = module.vnet.public-subnet-id[1]
//}
