variable "network_watcher" {
  description = "A map of network watcher configuration"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      tags                = map(any)
      use_existing        = bool
    }
  ))
}

variable "virtual_networks" {
  description = "A map of virtual networks"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      location            = string
      address_space       = list(string)
      dns_servers         = optional(list(string), [])
      bgp_community       = optional(string)
      ddos_protection_plan = optional(object(
        {
          id     = string
          enable = bool
        }
        ), {
        id     = ""
        enable = false
      })
      edge_zone               = optional(string)
      flow_timeout_in_minutes = optional(number, 30)
      tags                    = map(any)
    }
  ))
}

variable "subnets" {
  description = "A map of subnets to assign to a vNet"
  type = map(object(
    {
      name                = string
      resource_group_name = string
      virtual_network_key = string
      address_prefixes    = list(string)
      delegation = map(object(
        {
          name = optional(string)
          service_delegation = optional(object(
            {
              name    = optional(string)
              actions = optional(list(string))
            }
          ))
        }
        )
      )
      private_endpoint_network_policies_enabled     = optional(bool, true)
      private_link_service_network_policies_enabled = optional(bool, true)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))
      enable_nat_gateway                            = bool
      nat_gateway_key                               = string
    }
  ))
}

variable "public_ip_addresses" {
  description = "A map of public IP addresses"
  type = map(object(
    {
      allocation_method       = string
      domain_name_label       = string
      ddos_protection_mode    = string
      ddos_protection_plan_id = optional(string)
      edge_zone               = optional(string)
      idle_timeout_in_minutes = number
      ip_version              = string
      ip_tags                 = optional(map(any), {})
      location                = string
      name                    = string
      public_ip_prefix_id     = optional(string)
      resource_group_name     = string
      reverse_fqdn            = string
      sku                     = string
      sku_tier                = string
      tags                    = map(any)
      zones                   = list(string)
    }
  ))
}

variable "nat_gateways" {
  description = "A map of NAT gateways"
  type = map(object(
    {
      idle_timeout_in_minutes = number
      location                = string
      name                    = string
      resource_group_name     = string
      sku_name                = string
      tags                    = map(any)
      zones                   = list(string)
    }
  ))
}

variable "route_tables" {
  description = "A map of route tables"
  type = map(object(
    {
      disable_bgp_route_propagation = bool
      name                          = string
      location                      = string
      resource_group_name           = string
      tags                          = map(any)
    }
  ))
}

variable "routes" {
  description = "A map of routes and their association"
  type = map(object(
    {
      address_prefix         = string
      name                   = string
      next_hop_in_ip_address = string
      next_hop_type          = string
      resource_group_name    = string
      route_table_key        = string
    }
  ))
}