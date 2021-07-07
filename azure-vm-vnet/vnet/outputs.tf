output "vnet" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet-id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet-cidr" {
  value = azurerm_virtual_network.vnet.address_space
}

output "public-subnet" {
  value = azurerm_subnet.public-subnet.*.name
}

output "public-subnet-id" {
  value = azurerm_subnet.public-subnet.*.id
}

output "public-subnet-cidr" {
  value = azurerm_subnet.public-subnet.*.address_prefix
}

output "private-subnet" {
  value = azurerm_subnet.private-subnet.*.name
}

output "private-subnet-id" {
  value = azurerm_subnet.private-subnet.*.id
}

output "private-subnet-cidr" {
  value = azurerm_subnet.private-subnet.*.address_prefix
}

//output "public-ip-prefix" {
//  value = azurerm_public_ip_prefix.public-ip-prefix.name
//}
//
//output "public-ip-prefix-id" {
//  value = azurerm_public_ip_prefix.public-ip-prefix.id
//}
//
//output "public-ip-prefix-length" {
//  value = azurerm_public_ip_prefix.public-ip-prefix.prefix_length
//}