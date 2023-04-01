provider "azurerm" {
  features {}
}

module "networking" {
  source         = "./modules/networking"
  resource_group = var.resource_group
  vnet       = var.vnet
  VM  = var.VM
}

