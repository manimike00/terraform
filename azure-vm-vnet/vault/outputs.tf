output "vault_name" {
  value = azurerm_key_vault.vault.name
}

output "vault_id" {
  value = azurerm_key_vault.vault.id
}

output "vault_tenant_id" {
  value = azurerm_key_vault.vault.tenant_id
}

output "vault_uri" {
  value = azurerm_key_vault.vault.vault_uri
}

output "vault_key_name" {
  value = azurerm_key_vault_key.test.name
}

output "vault_key_version" {
  value = azurerm_key_vault_key.test.version
}

output "disk_encryption_set_id" {
  value = azurerm_disk_encryption_set.test.id
}