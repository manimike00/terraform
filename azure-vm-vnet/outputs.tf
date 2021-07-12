//# Module Resource Group
//output "rg" {
//  value = module.rg.rg
//}
//
//# Module Vnet
//output "vnet" {
//  value = module.vnet.vnet
//}
//
//output "vnet-id" {
//  value = module.vnet.vnet-id
//}
//
//output "vnet-cidr" {
//  value = module.vnet.vnet-cidr
//}
//
//output "public-subnet" {
//  value = module.vnet.*.public-subnet
//}
//
//output "public-subnet-id" {
//  value = module.vnet.public-subnet-id
//}
//
//output "public-subnet-cidr" {
//  value = module.vnet.public-subnet-cidr
//}
//
//output "private-subnet" {
//  value = module.vnet.private-subnet
//}
//
//output "private-subnet-id" {
//  value = module.vnet.private-subnet-id
//}
//
//output "private-subnet-cidr" {
//  value = module.vnet.private-subnet-cidr
//}
//
////output "public-ip-prefix" {
////  value = module.vnet.public-ip-prefix
////}
////
////output "public-ip-prefix-id" {
////  value = module.vnet.public-ip-prefix-id
////}
////
////output "public-ip-prefix-length" {
////  value = module.vnet.public-ip-prefix-length
////}
////
////# Module VM

//output "vault_name" {
//  value = module.vault.vault_name
//}
//
//output "vault_id" {
//  value = module.vault.vault_id
//}
//
//output "vault_tenant_id" {
//  value = module.vault.vault_tenant_id
//}
//
//output "vault_uri" {
//  value = module.vault.vault_uri
//}
//
//output "vault_access_policy_application_id" {
//  value = module.vault.vault_access_policy_application_id
//}
//
//output "vault_access_policy_certificate_permissions" {
//  value = module.vault.vault_access_policy_certificate_permissions
//}
//
//output "vault_access_policy_key_permissions" {
//  value = module.vault.vault_access_policy_key_permissions
//}
//
//output "vault_access_policy_secret_permissions" {
//  value = module.vault.vault_access_policy_secret_permissions
//}
//
//output "vault_access_policy_storage_permissions" {
//  value = module.vault.vault_access_policy_storage_permissions
//}
//
//output "vault_key_name" {
//  value = module.vault.vault_key_name
//}
//
//output "vault_key_version" {
//  value = module.vault.vault_key_version
//}

output "disk_encryption_set_id" {
  value = module.vault.disk_encryption_set_id
}