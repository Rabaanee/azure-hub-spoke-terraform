variable "location" {
  description = "Azure region"
  type        = string
}

variable "hub_rg" {
  description = "Hub network resource group"
  type        = string
}

variable "spoke_rg" {
  description = "Spoke network resource group"
  type        = string
}
