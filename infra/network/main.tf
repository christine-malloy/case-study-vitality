locals {
  namespace = "vitality"
  stage     = "dev"
  name      = "app"

  primary_cidr_block = "10.0.0.0/16"
}

module "vpc" {
  source = "cloudposse/vpc/aws"

  namespace = local.namespace
  stage     = local.stage
  name      = local.name

  ipv4_primary_cidr_block = local.primary_cidr_block

  assign_generated_ipv6_cidr_block = false
}

module "public_private_subnets" {
  source = "cloudposse/dynamic-subnets/aws"

  namespace          = local.namespace
  stage              = local.stage
  name               = local.name
  attributes         = ["public-private"]
  availability_zones = ["us-east-1a", "us-east-1b"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
  ipv4_cidr_block    = [cidrsubnet(local.primary_cidr_block, 4, 0)]
}

module "private_only_subnets" {
  source = "cloudposse/dynamic-subnets/aws"

  namespace          = local.namespace
  stage              = local.stage
  name               = local.name
  attributes         = ["private-only"]
  availability_zones = ["us-east-1c", "us-east-1d"]
  vpc_id             = module.vpc.vpc_id
  igw_id             = [module.vpc.igw_id]
  ipv4_cidr_block    = [cidrsubnet(local.primary_cidr_block, 4, 1)]
}