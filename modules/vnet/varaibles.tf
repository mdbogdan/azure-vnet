variable "rg_name" {
  description = "Resource‑group name. Allows reuse across subscriptions."
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the VNET"
  type        = string
}

variable "address_space" {
  description = "Address space, e.g. [\"10.0.0.0/16\"]"
  type        = list(string)
}

variable "create_default_subnet" {
  description = "Whether to create a /24 default subnet"
  type        = bool
  default     = true
}

variable "create_nsg" {
  description = "Create a Network Security Group and attach to default subnet"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}
