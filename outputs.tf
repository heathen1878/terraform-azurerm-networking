output "network_watcher" {
  value = try(azurerm_network_watcher.network_watcher, null)
}

output "virtual_network" {
  value = azurerm_virtual_network.virtual_network
}

output "subnet" {
  value = azurerm_subnet.subnet
}