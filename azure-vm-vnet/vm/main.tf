locals {
  type = var.type
}

data "template_file" "volume" {
  template = file("${path.module}/volume.sh")
}

resource "azurerm_public_ip" "public_ip" {
  count               = var.type == "public" ? 1 : 0
  name                = "${var.environment}-${var.project}-ip"
  resource_group_name = var.rg
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  count               = 1
  name                = "${var.environment}-${var.project}-nic"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "${var.environment}-${var.project}-ip-conf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.type == "public" ? azurerm_public_ip.public_ip[count.index].id : null
  }

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

resource "azurerm_virtual_machine" "vm" {
  depends_on            = [azurerm_network_interface.nic]
  count                 = 1
  name                  = "${var.environment}-${var.project}-vm"
  location              = var.location
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.environment}-${var.project}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.hostname
    admin_username = var.username
    admin_password = var.password
    custom_data    = var.environment == "bastion" ? null : data.template_file.volume.rendered
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

resource "azurerm_managed_disk" "managed-disk" {
  depends_on           = [azurerm_virtual_machine.vm]
  count                = var.environment == "bastion" ? 0 : 1
  name                 = "${var.environment}-${var.project}-maneged-disk"
  location             = var.location
  resource_group_name  = var.rg
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 50

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach-disk" {
  depends_on         = [azurerm_managed_disk.managed-disk]
  count              = var.environment == "bastion" ? 0 : 1
  managed_disk_id    = azurerm_managed_disk.managed-disk[count.index].id
  virtual_machine_id = azurerm_virtual_machine.vm[count.index].id
  lun                = "50"
  caching            = "ReadWrite"
}