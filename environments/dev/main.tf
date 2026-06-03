# Temporary import blocks to bring existing resources into state
import {
  to = module.resource_groups.azurerm_resource_group.rg["rg-dev-microservices"]
  id = "/subscriptions/453f09cc-5afa-481e-8340-61839b6b323c/resourceGroups/rg-dev-microservices"
}

import {
  to = module.acr.azurerm_container_registry.acr["acrdevms001"]
  id = "/subscriptions/453f09cc-5afa-481e-8340-61839b6b323c/resourceGroups/rg-dev-microservices/providers/Microsoft.ContainerRegistry/registries/acrdevms001"
}

import {
  to = module.aks.azurerm_kubernetes_cluster.aks["aks-dev-cluster"]
  id = "/subscriptions/453f09cc-5afa-481e-8340-61839b6b323c/resourceGroups/rg-dev-microservices/providers/Microsoft.ContainerService/managedClusters/aks-dev-cluster"
}

module "resource_groups" {
  source = "../../modules/resource_group"

  resource_groups = var.resource_groups
}

module "acr" {
  source = "../../modules/acr"

  registries = {
    for k, v in var.registries : k => merge(v, {
      resource_group_name = module.resource_groups.resource_group_names[v.resource_group_key]
    })
  }

  depends_on = [module.resource_groups]
}

module "aks" {
  source = "../../modules/aks"

  clusters = {
    for k, v in var.clusters : k => merge(v, {
      resource_group_name = module.resource_groups.resource_group_names[v.resource_group_key]
    })
  }

  depends_on = [module.resource_groups]
}
