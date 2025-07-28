terraform {
  backend "azurerm" {
    resource_group_name   = "rg-tfstate"
    storage_account_name  = "tfstateremotetesting"
    container_name        = "tfstate"
    key                   = "dev.terraform.tfstate"
  }
  }

provider "azurerm" {
  features {}
}

module "network" {
  source              = "../../modules/vnet"
  rg_name             = "rg-dev-eastus"
  location            = "eastus"
  vnet_name           = "vnet-dev"
  address_space       = ["10.10.0.0/16"]
  tags = {
    env     = "dev"
    region  = "eastus"
    owner   = "team‑alpha"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-dev"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  resource_group_name = module.network.rg_name
  location            = module.network.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }
  network_interface_ids = [azurerm_network_interface.nic.id]
  tags = module.network.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-dev"
  location            = module.network.location
  resource_group_name = module.network.rg_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = module.network.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = "st${random_integer.rand.result}"
  location                 = module.network.location
  resource_group_name      = module.network.rg_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = module.network.tags
}

resource "random_integer" "rand" {
  min = 10000
  max = 99999
}

resource "azurerm_key_vault" "dev" {
  name                        = "kv${random_integer.rand.result}"
  location                    = module.network.location
  resource_group_name         = module.network.rg_name
  tenant_id                   = "10744641-269f-4092-a019-71e10aa4c549"
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  tags                        = module.network.tags
}

output "vm_public_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}
