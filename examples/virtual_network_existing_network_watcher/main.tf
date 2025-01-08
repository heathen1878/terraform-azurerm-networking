locals {

  location = "uksouth"

  subnets = {
    delegation = {
      name = "delegated"
      address_prefixes = [
        "192.168.0.0/25"
      ]
      delegation = {
        web_app_vnet_integration = {
          name = "web_app_vnet_integration"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action"
            ]
          }
        }
      }
    }
    no_delegation = {
      name = "no-delegated"
      address_prefixes = [
        "192.168.0.128/25"
      ]
    }
  }

  tags = {
    IaC   = "Terraform"
    Usage = "Networking Example"
  }
}

module "resource_group_naming" {
  source  = "heathen1878/naming/azurecaf"
  version = "1.0.1"

  resource_name = "networking-example"
  resource_type = "azurerm_resource_group"
}

module "virtual_network_naming" {
  source  = "heathen1878/naming/azurecaf"
  version = "1.0.1"

  resource_name = "networking-example"
  resource_type = "azurerm_virtual_network"
}

module "resource_groups" {
  source  = "heathen1878/resource-groups/azurerm"
  version = "3.0.0"

  resource_group_name     = module.resource_group_naming.resource_name
  resource_group_location = local.location
  resource_group_tags     = local.tags
}

module "networking" {

  source = "../../"

  virtual_network_name = module.virtual_network_naming.resource_name
  resource_group_name  = module.resource_groups.resource_group_name
  location             = local.location
  subnets              = local.subnets
}