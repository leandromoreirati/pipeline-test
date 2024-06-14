variable "name" {
  type        = string
  default     = null
  description = "Name of the resource group. Must be unique on your Azure subscription."
}

variable "location" {
  type        = string
  default     = null
  description = "The location where the resource group should be created."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resource."
}