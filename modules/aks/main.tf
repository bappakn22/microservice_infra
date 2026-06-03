resource "azurerm_kubernetes_cluster" "aks" {
  for_each = var.clusters

  name                = each.key
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  dns_prefix          = each.value.dns_prefix
  sku_tier            = each.value.sku_tier
  tags                = each.value.tags

  default_node_pool {
    name                 = each.value.default_node_pool.name
    node_count           = each.value.default_node_pool.node_count
    vm_size              = each.value.default_node_pool.vm_size
    auto_scaling_enabled = each.value.default_node_pool.enable_auto_scaling
    min_count            = each.value.default_node_pool.min_count
    max_count            = each.value.default_node_pool.max_count
    vnet_subnet_id       = each.value.default_node_pool.vnet_subnet_id
    type                 = each.value.default_node_pool.type
  }

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.type == "UserAssigned" ? identity.value.identity_ids : null
    }
  }

  dynamic "network_profile" {
    for_each = each.value.network_profile != null ? [each.value.network_profile] : []
    content {
      network_plugin    = network_profile.value.network_plugin
      load_balancer_sku = network_profile.value.load_balancer_sku
      network_policy    = network_profile.value.network_policy
    }
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  # Use conditional logic to flatten the extra_node_pools into a structure suitable for for_each
  # Format: cluster_name.node_pool_name => node_pool_config
  for_each = merge([
    for cluster_name, cluster_config in var.clusters : {
      for pool_name, pool_config in cluster_config.extra_node_pools :
      "${cluster_name}.${pool_name}" => merge(pool_config, { cluster_id = azurerm_kubernetes_cluster.aks[cluster_name].id, name = pool_name })
    }
  ]...)

  name                  = each.value.name
  kubernetes_cluster_id = each.value.cluster_id
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  auto_scaling_enabled  = each.value.enable_auto_scaling
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  vnet_subnet_id        = each.value.vnet_subnet_id
  tags                  = each.value.tags
}
