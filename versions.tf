terraform {
  required_version = "1.5.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
<<<<<<< Updated upstream
      version = "=3.45.0"
      configuration_aliases = [
        azurerm.global
      ]
=======
      version = ">= 3.74.0, <= 3.116.0"
>>>>>>> Stashed changes
    }
  }
}
