terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# Optional subnet
resource "azurerm_subnet" "default" {
  count                = var.create_default_subnet ? 1 : 0
  name                 = "default"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 0)]
}

# Optional NSG
resource "azurerm_network_security_group" "this" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.vnet_name}-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags
}

# Attach NSG to subnet if both exist
resource "azurerm_subnet_network_security_group_association" "default" {
  count                     = var.create_default_subnet && var.create_nsg ? 1 : 0
  subnet_id                 = azurerm_subnet.default[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}
