# Networking module

## Tests

[![Terratest](...)]

## Security

[![Dependabot](https://img.shields.io/badge/dependabot-active-brightgreen?style=flat-square&logo=dependabot)](...)

## Examples

[...](./examples/.../README.md)

## Usage

```shell
# Typically nested within another module to manage IAM
module "networking" {

    source ="heathen1878/networking/azurerm"
    version = "1.0.0"

    # Three mandatory parameters
}
```

## Version 1.0.0






## Network Watcher

Creates or gets the network watcher for the region and subscription depending on whether the use_existing key value is true or false. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## Virtual Network

Creates one or more virtual networks and returns the virtual network attributes for other modules to consume. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## Subnets

Creates one or more subnets. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## Public IP addresses

Creates one or more public IP addresses. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## NAT Gateway

Creates one or more NAT gateways. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## Route tables

Creates one or more route tables. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## User defined routes

Creates one or more user defined routes and assigns them to an associated route table. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).

## NSGs, rules and associated subnet

Creates one or more network security groups with associated security rules, then assign the NSGs to a defined subnet. See example [usage](https://raw.githubusercontent.com/heathen1878/terraform-azurerm-networking/main/terraform.tfvars.example).
