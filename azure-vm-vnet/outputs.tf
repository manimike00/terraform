# Module Resource Group
output "rg" {
  value = module.rg.rg
}

# Module Vnet
output "vnet" {
  value = module.vnet.vnet
}

output "vnet-id" {
  value = module.vnet.vnet-id
}

output "vnet-cidr" {
  value = module.vnet.vnet-cidr
}

output "public-subnet" {
  value = module.vnet.public-subnet
}

output "public-subnet-id" {
  value = module.vnet.public-subnet-id
}

output "public-subnet-cidr" {
  value = module.vnet.public-subnet-cidr
}

output "private-subnet" {
  value = module.vnet.private-subnet
}

output "private-subnet-id" {
  value = module.vnet.private-subnet-id
}

output "private-subnet-cidr" {
  value = module.vnet.private-subnet-cidr
}

output "public-ip-prefix" {
  value = module.vnet.public-ip-prefix
}

output "public-ip-prefix-id" {
  value = module.vnet.public-ip-prefix-id
}

output "public-ip-prefix-length" {
  value = module.vnet.public-ip-prefix-length
}

# Module VM