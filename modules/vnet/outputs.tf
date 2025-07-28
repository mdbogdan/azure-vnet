output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "ID of the created VNET"
}

output "subnet_id" {
  value       = var.create_default_subnet ? azurerm_subnet.default[0].id : null
}

output "nsg_id" {
  value       = var.create_nsg ? azurerm_network_security_group.this[0].id : null
}
output "location" {
  description = "Azure region used by this VNET"
  value       = var.location
}

output "rg_name" {
  description = "Resource‑group name"
  value       = azurerm_resource_group.this.name
}

output "tags" {
  description = "Tags applied to all resources in the module"
  value       = var.tags
}
