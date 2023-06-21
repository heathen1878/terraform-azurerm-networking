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
    }
  ))
}