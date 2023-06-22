resource "azurerm_network_watcher" "network_watcher" {
  for_each = {
    for key, value in var.network_watcher : key => value
    if value.use_existing == false
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  tags                = each.value.tags
}

resource "azurerm_virtual_network" "virtual_network" {

  for_each = var.virtual_networks

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers
  bgp_community       = each.value.bgp_community

  dynamic "ddos_protection_plan" {
    for_each = each.value.ddos_protection_plan.enable == true ? { "ddos" = "enabled" } : {}

    content {
      id     = ddos_protection_plan.id
      enable = ddos_protection_plan.enable
    }
  }

  edge_zone               = each.value.edge_zone
  flow_timeout_in_minutes = each.value.flow_timeout_in_minutes
  tags                    = each.value.tags

  lifecycle {
    ignore_changes = [
      dns_servers # DNS is managed by terraform-azure-networking/dns
    ]
  }

  depends_on = [
    azurerm_network_watcher.network_watcher
  ]
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network[each.value.virtual_network_key].name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = each.value.delegation

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.service_endpoints
  service_endpoint_policy_ids                   = each.value.service_endpoint_policy_ids
}

resource "azurerm_route_table" "route_table" {
  for_each = var.route_tables

  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = each.value.tags
}

resource "azurerm_route" "route" {
  for_each = var.routes

  name                   = each.value.name
  resource_group_name    = each.value.resource_group_name
  route_table_name       = azurerm_route_table.route_table[each.value.route_table_key].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_in_ip_address : null
}
