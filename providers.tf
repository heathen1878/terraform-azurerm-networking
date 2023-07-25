provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "global"
  subscription_id = var.management_subscription
  features {}
}