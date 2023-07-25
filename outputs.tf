output "network_watcher" {
  value = try(azurerm_network_watcher.network_watcher, null)
}

output "virtual_network" {
  value = azurerm_virtual_network.virtual_network
}

output "subnet" {
  value = azurerm_subnet.subnet
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip_address
}

output "azure_nat_gateway" {
  value = azurerm_nat_gateway.nat_gateway
}

output "network_security_group" {
  value = azurerm_network_security_group.nsg
}
