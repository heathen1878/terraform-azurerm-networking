data "azurerm_network_watcher" "network_watcher" {

  for_each = {
    for key, value in var.network_watcher : key => value
    if value.use_existing == true
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name

}