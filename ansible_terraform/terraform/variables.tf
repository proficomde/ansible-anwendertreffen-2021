variable "location" {
  type    = string
  default = "West Europe"
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "azurerm_resource_group" {
  type = string
}

variable "number_of_vms" {
  description = "This is the number of VMs needed"
  type        = number
  default     = 1
}

variable "image_publisher" {
  type = string
}

variable "image_offer" {
  type = string
}

variable "image_sku" {
  type = string
}

variable "image_version" {
  type = string
}