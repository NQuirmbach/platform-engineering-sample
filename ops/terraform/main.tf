terraform {
  backend "azurerm" {
    resource_group_name = "terraform-backend"
    storage_account_name = "tfbackend1727941381"
    container_name = "tfstate"
    key = "terraform.tfstate"
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
  tags = {
    env = "test"
    app = "k8s-cluster"
    purpose = "platform-engineering"
  }
}

resource "azurerm_resource_group" "rg" {
  name = "k8s-cluster-rg"
  location = var.azure_location
  tags = local.tags
}
