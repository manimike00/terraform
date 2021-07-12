locals {
  type = var.type
}

resource "azurerm_public_ip" "public_ip" {
  count               = var.type == "public" ? 1 : 0
  name                = "${var.environment}-${var.project}-ip"
  resource_group_name = var.rg
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.environment}-${var.project}-nic"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.environment}-${var.project}-ip-conf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.type == "public" ? azurerm_public_ip.public_ip[0].id : null
  }

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

//resource "azurerm_virtual_machine" "vm" {
//  depends_on            = [azurerm_network_interface.nic]
//  name                  = "${var.environment}-${var.project}-vm"
//  location              = var.location
//  resource_group_name   = var.rg
//  network_interface_ids = [azurerm_network_interface.nic.id]
//  vm_size               = "Standard_DS1_v2"
//
//  # Uncomment this line to delete the OS disk automatically when deleting the VM
//  delete_os_disk_on_termination = true
//
//  # Uncomment this line to delete the data disks automatically when deleting the VM
//  delete_data_disks_on_termination = true
//
//  storage_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "18.04-LTS"
//    version   = "latest"
//  }
//  storage_os_disk {
//    name              = "${var.environment}-${var.project}-disk"
//    caching           = "ReadWrite"
//    create_option     = "FromImage"
//    managed_disk_type = "Standard_LRS"
//
//  }
//  os_profile {
//    computer_name  = var.hostname
//    admin_username = var.username
//    admin_password = var.password
//    custom_data    = var.custom_data
//  }
//
//  os_profile_linux_config {
//    disable_password_authentication = false
//  }
//  tags = {
//    environment = var.environment
//    source      = "Terraform"
//    owner       = var.owner
//    project     = var.project
//  }
//}

resource "azurerm_availability_set" "available_set" {
  depends_on                   = [azurerm_network_interface.nic]
  name                         = "${var.environment}-${var.project}-available-set"
  resource_group_name          = var.rg
  location                     = var.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  depends_on                 = [azurerm_network_interface.nic]
  name                       = "${var.environment}-${var.project}-vm"
  resource_group_name        = var.rg
  location                   = var.location
  availability_set_id        = azurerm_availability_set.available_set.id
  size                       = var.vm_size
//  encryption_at_host_enabled = "true"
  network_interface_ids      = [azurerm_network_interface.nic.id]

  disable_password_authentication = false
  admin_username                  = var.username
  admin_password                  = var.password
  custom_data                     = var.custom_data

  os_disk {
    name                   = "${var.environment}-${var.project}-os-disk"
    caching                = "ReadWrite"
    storage_account_type   = var.storage_account_type
    disk_encryption_set_id = var.disk_encryption_set_id
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}