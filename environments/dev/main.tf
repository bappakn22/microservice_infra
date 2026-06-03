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
