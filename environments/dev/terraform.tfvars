resource_groups = {
  "rg-dev-microservices" = {
    location = "East US"
    tags = {
      environment = "dev"
      project     = "microservices"
    }
  }
}

registries = {
  "acrdevms001" = {
    resource_group_key = "rg-dev-microservices"
    location           = "East US"
    sku                = "Standard"
    admin_enabled      = true
  }
}

clusters = {
  "aks-dev-cluster" = {
    resource_group_key = "rg-dev-microservices"
    location           = "East US"
    dns_prefix         = "aksdev"
    sku_tier           = "Free"

    default_node_pool = {
      name                = "systempool"
      node_count          = 1
      vm_size             = "Standard_D2s_v3"
      enable_auto_scaling = false
    }

    extra_node_pools = {
      "userpool" = {
        vm_size             = "Standard_D2s_v3"
        node_count          = 1
        enable_auto_scaling = true
        min_count           = 1
        max_count           = 3
      }
    }

    tags = {
      environment = "dev"
    }
  }
}
