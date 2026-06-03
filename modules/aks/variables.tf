variable "clusters" {
  description = "Map of AKS clusters to create"
  type = map(object({
    resource_group_name = string
    location            = string
    dns_prefix          = string
    sku_tier            = optional(string, "Free")
    tags                = optional(map(string), {})

    default_node_pool = object({
      name                = string
      node_count          = optional(number, 1)
      vm_size             = optional(string, "Standard_D2s_v3")
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number, null)
      max_count           = optional(number, null)
      vnet_subnet_id      = optional(string, null)
      type                = optional(string, "VirtualMachineScaleSets")
    })

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), [])
    }), { type = "SystemAssigned" })

    network_profile = optional(object({
      network_plugin    = optional(string, "azure")
      load_balancer_sku = optional(string, "standard")
      network_policy    = optional(string, null)
    }))

    extra_node_pools = optional(map(object({
      vm_size             = string
      node_count          = optional(number, 1)
      enable_auto_scaling = optional(bool, false)
      min_count           = optional(number, null)
      max_count           = optional(number, null)
      vnet_subnet_id      = optional(string, null)
      tags                = optional(map(string), {})
    })), {})
  }))
}
