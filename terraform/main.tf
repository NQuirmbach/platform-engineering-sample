terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend"
    storage_account_name = "tfbackend1727941381"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  vm_admin_user = "clusteradmin"
  tags = {
    env     = var.environment
    app     = "k8s-cluster"
    purpose = "platform-engineering"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "k8s-cluster-rg-${var.environment}"
  location = var.azure_location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "k8s-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "k8s-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}
