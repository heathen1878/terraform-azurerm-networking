output "network_watcher" {
  value = azurerm_network_watcher.network_watcher
}

output "virtual_network" {
  value = azurerm_virtual_network.virtual_network
}

output "subnet" {
  value = azurerm_subnet.subnet
}