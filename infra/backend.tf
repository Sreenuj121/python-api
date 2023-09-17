terraform {
  backend "azurerm" {
    resource_group_name  = "DefaultResourceGroup-WUS"
    storage_account_name = "pythonsan1"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
