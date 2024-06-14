terraform {
  backend "azurerm" {
    resource_group_name = "rg-terraform"
    storage_account_name = "stateterraformdemo"
    container_name = "terraform-state"
    key = "backstage/rg.tfstate"
  }
}