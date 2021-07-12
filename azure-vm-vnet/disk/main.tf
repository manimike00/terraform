data "azurerm_subscription" "current" {}

resource "azurerm_managed_disk" "managed-disk" {
  name                   = "${var.environment}-${var.project}-maneged-disk"
  location               = var.location
  resource_group_name    = var.rg
  storage_account_type   = "Standard_LRS"
  create_option          = "Empty"
  disk_size_gb           = var.disk_size_gb
  disk_encryption_set_id = var.disk_encryption_set_id

  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
    project     = var.project
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "attach-disk" {
  depends_on         = [azurerm_managed_disk.managed-disk]
  managed_disk_id    = azurerm_managed_disk.managed-disk.id
  virtual_machine_id = var.vm_id
  lun                = var.disk_size_gb
  caching            = "ReadWrite"
}

//resource "azurerm_virtual_machine_extension" "disk-encryption" {
//  depends_on           = [azurerm_virtual_machine_data_disk_attachment.attach-disk]
//  name                 = "${var.environment}-${var.project}-disk-encryption"
//  virtual_machine_id   = var.vm_id
//  publisher            = "Microsoft.Azure.Security"
//  type                 = "AzureDiskEncryption"
//  type_handler_version = "2.2"
//
//  settings = <<SETTINGS
//{
//  "EncryptionOperation": "EnableEncryption",
//  "KeyVaultURL": "https://${var.vault_name}.vault.azure.net",
//  "KeyVaultResourceId": "/subscriptions/${data.azurerm_subscription.current.id}/resourceGroups/${var.rg}/providers/Microsoft.KeyVault/vaults/${var.vault_name}",
//  "KeyEncryptionKeyURL": "https://${var.vault_name}.vault.azure.net/keys/${var.vault_keyname}/${var.vault_keyversion}",
//  "KekVaultResourceId": "/subscriptions/${data.azurerm_subscription.current.id}/resourceGroups/${var.rg}/providers/Microsoft.KeyVault/vaults/${var.vault_name}",
//  "KeyEncryptionAlgorithm": "RSA-OAEP",
//  "VolumeType": "All"
//}
//SETTINGS
//}