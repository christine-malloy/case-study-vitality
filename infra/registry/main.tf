locals {
  namespace = "vitality"
  stage     = "dev"
  name      = "app"
}

module "ecr" {
  source = "cloudposse/ecr/aws"

  context   = module.this.context
  namespace = local.namespace
  stage     = local.stage
  name      = local.name
}

output "ecr_repositories" {
  value = module.ecr.repository_url_map
}
