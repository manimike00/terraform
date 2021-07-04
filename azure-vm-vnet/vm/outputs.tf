output "vm" {
  value = azurerm_virtual_machine.vm.name
}

output "vm-ip" {
  value = azurerm_virtual_machine.vm.id
}