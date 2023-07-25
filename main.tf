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
      dns_servers # DNS is managed by heathen1878/dns/azurerm
    ]
  }

  depends_on = [
    azurerm_network_watcher.network_watcher
  ]
}

resource "azurerm_virtual_network_peering" "global_to_environment_same_subscription" {
  for_each = {
    for key, value in var.virtual_network_peers : key => value
    if value.cross_subscription == false
  }

  name                      = format("%s-to-%s", each.value.peer_1_name, azurerm_virtual_network.virtual_network[each.value.peer_2_id].name)
  resource_group_name       = each.value.peer_1_rg
  virtual_network_name      = each.value.peer_1_name
  remote_virtual_network_id = azurerm_virtual_network.virtual_network[each.value.peer_2_id].id
}

resource "azurerm_virtual_network_peering" "global_to_environment_different_subscription" {
  for_each = {
    for key, value in var.virtual_network_peers : key => value
    if value.cross_subscription == true
  }

  provider                  = azurerm.global
  name                      = format("%s-to-%s", each.value.peer_1_name, azurerm_virtual_network.virtual_network[each.value.peer_2_id].name)
  resource_group_name       = each.value.peer_1_rg
  virtual_network_name      = each.value.peer_1_name
  remote_virtual_network_id = azurerm_virtual_network.virtual_network[each.value.peer_2_id].id
}

resource "azurerm_virtual_network_peering" "environment_to_global" {
  for_each = var.virtual_network_peers

  name                      = format("%s-to-%s", azurerm_virtual_network.virtual_network[each.value.peer_2_id].name, each.value.peer_1_name)
  resource_group_name       = azurerm_virtual_network.virtual_network[each.value.peer_2_id].resource_group_name
  virtual_network_name      = azurerm_virtual_network.virtual_network[each.value.peer_2_id].name
  remote_virtual_network_id = each.value.peer_1_id
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

resource "azurerm_public_ip" "public_ip_address" {
  for_each = var.public_ip_addresses

  name                    = each.value.name
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  allocation_method       = each.value.allocation_method
  ddos_protection_mode    = each.value.ddos_protection_mode
  ddos_protection_plan_id = each.value.ddos_protection_plan_id
  domain_name_label       = each.value.domain_name_label
  edge_zone               = each.value.edge_zone
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  ip_tags                 = each.value.ip_tags
  public_ip_prefix_id     = each.value.public_ip_prefix_id
  reverse_fqdn            = each.value.reverse_fqdn
  sku                     = each.value.sku
  sku_tier                = each.value.sku_tier
  zones                   = each.value.zones
  tags                    = each.value.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_nat_gateway" "nat_gateway" {
  for_each = var.nat_gateways

  name                    = each.value.name
  resource_group_name     = each.value.resource_group_name
  location                = each.value.location
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
  sku_name                = each.value.sku_name
  tags = merge(each.value.tags, {
    associated_ip_address = azurerm_public_ip.public_ip_address[each.key].name
  })
  zones = each.value.zones
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway" {
  for_each = {
    for key, value in var.subnets : key => value
    if value.enable_nat_gateway == true
  }

  subnet_id      = azurerm_subnet.subnet[each.key].id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[each.value.nat_gateway_key].id
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway" {
  for_each = var.nat_gateways

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[each.key].id
  public_ip_address_id = azurerm_public_ip.public_ip_address[each.key].id

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
  next_hop_in_ip_address = each.value.next_hop_type
}

resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsgs

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = var.nsg_rules

  # required
  name                        = each.value.name
  resource_group_name         = azurerm_network_security_group.nsg[each.value.key].resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[each.value.key].name

  priority  = each.value.priority
  protocol  = each.value.protocol
  direction = each.value.direction
  access    = each.value.access

  # optional
  description                  = each.value.description
  source_port_range            = each.value.source_port_range
  source_port_ranges           = each.value.source_port_ranges
  destination_port_range       = each.value.destination_port_range
  destination_port_ranges      = each.value.destination_port_ranges
  source_address_prefix        = each.value.source_address_prefix
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefix   = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
}

resource "azurerm_subnet_network_security_group_association" "nsg_to_subnet" {
  for_each = var.nsg_association

  subnet_id                 = azurerm_subnet.subnet[each.value.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.key].id
}