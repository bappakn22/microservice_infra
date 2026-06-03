variable "resource_groups" {
  description = "Resource groups configuration"
  type = map(object({
    location = string
    tags     = optional(map(string), {})
  }))
}

variable "registries" {
  description = "ACR configuration"
  type = map(object({
    resource_group_key = string
    location           = string
    sku                = optional(string, "Standard")
    admin_enabled      = optional(bool, false)
    tags               = optional(map(string), {})
  }))
}

variable "clusters" {
  description = "AKS configuration"
  type = map(object({
    resource_group_key = string
    location           = string
    dns_prefix         = string
    sku_tier           = optional(string, "Free")
    tags               = optional(map(string), {})

    default_node_pool = object({
      name                = string
      node_count          = optional(number, 1)
      vm_size             = optional(string, "Standard_DS2_v2")
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number, null)
      max_count           = optional(number, null)
    })

    extra_node_pools = optional(map(object({
      vm_size             = string
      node_count          = optional(number, 1)
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number, null)
      max_count           = optional(number, null)
    })), {})
  }))
}
