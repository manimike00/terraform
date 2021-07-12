//resource "azurerm_key_vault_key" "vault_key" {
//  name         = "${var.environment}-${var.project}-vault-key"
//  key_vault_id = azurerm_key_vault.vault.id
//  key_type     = "RSA"
//  key_size     = 2048
//
//  key_opts = [
//    "decrypt",
//    "encrypt",
//    "sign",
//    "unwrapKey",
//    "verify",
//    "wrapKey",
//  ]
//}
//
//resource "azurerm_disk_encryption_set" "disk_encryption_set" {
//  name                = "${var.environment}-${var.project}-disk-encryption-set"
//  resource_group_name = var.rg
//  location            = var.location
//  key_vault_key_id    = azurerm_key_vault_key.vault_key.id
//
//  identity {
//    type = "SystemAssigned"
//  }
//}
//
//resource "azurerm_key_vault_access_policy" "disk-policy" {
//  key_vault_id = azurerm_key_vault.vault.id
//
//  tenant_id = azurerm_disk_encryption_set.disk_encryption_set.identity.tenant_id
//  object_id = azurerm_disk_encryption_set.disk_encryption_set.identity.principal_id
//
//  key_permissions = [
//    "Get",
//    "WrapKey",
//    "UnwrapKey"
//  ]
//}


data "azurerm_client_config" "current" {}

# Generate a random vm name
resource "random_string" "vm-name" {
  length  = 8
  upper   = false
  number  = false
  lower   = true
  special = false
}

resource "azurerm_key_vault" "vault" {
  name                        = "${random_string.vm-name.result}-${var.project}-vault"
  location                    = var.location
  resource_group_name         = var.rg
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "premium"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
}

# grant the service principal/user access to the key vault to be able to create the key
resource "azurerm_key_vault_access_policy" "service-principal" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "create",
    "get",
    "delete",
    "list",
    "wrapkey",
    "unwrapkey",
    "get",
  ]

  secret_permissions = [
    "get",
    "delete",
    "set",
  ]

}

# then generate a key used to encrypt the disks
resource "azurerm_key_vault_key" "test" {
  name         = "${var.environment}-${var.project}-vault-key"
  key_vault_id = azurerm_key_vault.vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [azurerm_key_vault_access_policy.service-principal]
}

resource "azurerm_disk_encryption_set" "test" {
  name                = "${var.environment}-${var.project}-disk-encryption-set"
  resource_group_name = var.rg
  location            = var.location
  key_vault_key_id    = azurerm_key_vault_key.test.id

  identity {
    type = "SystemAssigned"
  }
}

# grant the Managed Identity of the Disk Encryption Set access to Read Data from Key Vault
resource "azurerm_key_vault_access_policy" "disk-encryption" {
  key_vault_id = azurerm_key_vault.vault.id

  key_permissions = [
    "create",
    "get",
    "delete",
    "list",
    "wrapkey",
    "unwrapkey",
    "get",
  ]

  tenant_id = azurerm_disk_encryption_set.test.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.test.identity.0.principal_id
}

data "azurerm_subscription" "current" {}

data "azurerm_role_definition" "reader" {
  name = "Reader"
}

# grant the Managed Identity of the Disk Encryption Set "Reader" access to the Key Vault
resource "azurerm_role_assignment" "disk-encryption-read-keyvault" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Reader"
  principal_id         = azurerm_disk_encryption_set.test.identity.0.principal_id
}