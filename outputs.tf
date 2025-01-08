output "network_watcher" {
  value = try(azurerm_network_watcher.this, null)
}

output "virtual_network" {
  value = azurerm_virtual_network.this
}

output "subnet" {
<<<<<<< Updated upstream
  value = azurerm_subnet.subnet
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip_address
}

output "network_security_group" {
  value = azurerm_network_security_group.nsg
}
=======
  value = azurerm_subnet.this
}

output "nat_gateway" {
  value = try(azurerm_nat_gateway.this, null)
}
>>>>>>> Stashed changes
