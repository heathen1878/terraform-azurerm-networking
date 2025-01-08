variable "bgp_community" {
  description = "The BGP community attribute"
  default     = null
  type        = string
}

variable "ddos_protection_plan" {
  description = "value"
  default     = {}
  type = map(object(
    {
      id     = string
      enable = bool
    }
  ))
}

<<<<<<< Updated upstream
variable "virtual_network_peers" {
  description = "A map of virtual network peerings"
  type = map(object(
    {
      cross_subscription = bool
      peer_1_id          = string
      peer_1_rg          = string
      peer_1_name        = string
      peer_2_id          = string
    }
  ))
=======
variable "location" {
  description = "The location where resources in this module should reside"
  type        = string
}

variable "use_existing_network_watcher" {
  description = "Should the existing network watcher be used?"
  default     = true
  type        = bool
}

variable "network_watcher_name" {
  description = "The name of the network watcher"
  default     = null
  type        = string
}

variable "resource_group_name" {
  description = "The resource group where the resources in this module should reside"
  type        = string
>>>>>>> Stashed changes
}

variable "subnets" {
  description = "A map of subnets to assign to a vNet"
  default     = {}
  type = map(object(
    {
      name             = string
      address_prefixes = list(string)
      delegation = optional(map(object(
        {
          name = optional(string)
          service_delegation = optional(object(
            {
              name    = optional(string)
              actions = optional(list(string))
            }
          ))
        }
      )), {})
      private_endpoint_network_policies_enabled     = optional(bool, true)
      private_link_service_network_policies_enabled = optional(bool, true)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))
      enable_nat_gateway                            = optional(bool, false)
      nat_gateway_key                               = optional(string, null)
    }
  ))
}

variable "tags" {
  description = "A map of tags that should be assigned to resources in this module"
  default     = {}
  type        = map(any)
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "virtual_network_address_space" {
  description = "A list of IP address space to assign to the virtual network"
  default = [
    "192.168.0.0/16"
  ]
  type = list(string)
}

variable "virtual_network_dns_servers" {
  description = "The DNS servers to assign to the virtual network - default is to use Azure DNS"
  default     = []
  type        = list(string)
}

variable "virtual_network_edge_zone" {
  description = "The edge zone in the Azure region where the virtual network should reside"
  default     = null
  type        = string
}

variable "virtual_network_flow_timeout_in_minutes" {
  description = "The flow timeout for infra VM flow connection tracking in minutes"
  default     = 4
  type        = number
}

variable "virtual_network_peers" {
  description = "A map of virtual network peerings"
  default     = {}
  type = map(object(
    {
      peer_1_id   = string
      peer_1_rg   = string
      peer_1_name = string
      peer_2_id   = string
    }
  ))
}

variable "public_ip_addresses" {
  description = "A map of public IP addresses"
  default     = {}
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
  default     = {}
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
  default     = {}
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
  default     = {}
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

variable "nsgs" {
  description = "A map of NSGs"
  default     = {}
  type = map(object(
    {
      name                = string
      location            = string
      resource_group_name = string
      tags                = map(any)
    }
  ))
}

variable "nsg_rules" {
  description = "A map of NSG rules"
  default     = {}
  type = map(object(
    {
      name                         = string
      priority                     = number
      protocol                     = string
      direction                    = string
      access                       = string
      description                  = string
      source_port_range            = string
      source_port_ranges           = list(string)
      destination_port_range       = string
      destination_port_ranges      = list(string)
      source_address_prefix        = string
      source_address_prefixes      = list(string)
      destination_address_prefix   = string
      destination_address_prefixes = list(string)
      key                          = string
    }
  ))
}

variable "nsg_association" {
  description = "A map of NSGs and the subnet to associate with"
  default     = {}
  type = map(object(
    {
      nsg_name = string
      key      = string
    }
  ))
}

variable "management_subscription" {
  description = "The subscription to use for the AzureRM provider alias. It's only used if cross_subscription vNet peers are required."
  type        = string
}