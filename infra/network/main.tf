locals {
  namespace = "vitality"
  stage     = "dev"
  name      = "app"
  bastion = {
    instance_type               = "t2.micro"
    associate_public_ip_address = true
  }

  primary_cidr_block = "10.0.0.0/16"
  ssh_key_path       = ".pem/vitality-bastion.pub"
}

module "vitality" {
  source = "cloudposse/label/null"

  namespace = local.namespace
  stage     = local.stage
  name      = local.name
  delimiter = "-"

  context = module.this.context
}

module "vpc" {
  source = "cloudposse/vpc/aws"


  namespace = local.namespace
  stage     = local.stage
  name      = local.name
  attributes = ["vpc"]

  ipv4_primary_cidr_block = local.primary_cidr_block

  assign_generated_ipv6_cidr_block = false

  context = module.vitality.context
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

  context = module.vitality.context
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

  context = module.vitality.context
}
module "sg_primary" {
  source = "cloudposse/security-group/aws"

  attributes = ["primary"]

  allow_all_egress = true

  rules = [
    {
      key         = "ssh"
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = null # preferable to self = false
      description = "Allow SSH from anywhere"
    },
    {
      key         = "HTTP"
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = []
      self        = true
      description = "Allow HTTP from inside the security group"
    }
  ]

  vpc_id = module.vpc.vpc_id

  context = module.vitality.context
}

module "sg_postgres" {
  source = "cloudposse/security-group/aws"

  attributes = ["postgres"]

  allow_all_egress = true

  rule_matrix = [
    {
      source_security_group_ids = [module.sg_primary.id]
      prefix_list_ids           = []
      rules = [
        {
          key         = "postgres"
          type        = "ingress"
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          description = "Allow Postgres access from trusted security groups"
        }
      ]
    }
  ]

  vpc_id = module.vpc.vpc_id

  context = module.vitality.context
}

module "aws_key_pair" {
  source = "cloudposse/key-pair/aws"

  attributes          = ["ssh", "key"]
  ssh_public_key_path = local.ssh_key_path
  generate_ssh_key    = true

  context = module.vitality.context
}

module "bastion_label" {
  source = "cloudposse/label/null"

  namespace  = local.namespace
  stage      = local.stage
  name       = "bastion"
  attributes = ["public"]
  delimiter  = "-"

  context = module.vitality.context
}

# let's us shell into the VPC
module "ec2_bastion" {
  source = "cloudposse/ec2-bastion-server/aws"

  enabled = module.this.enabled

  instance_type               = local.bastion.instance_type
  security_groups             = [module.vpc.vpc_default_security_group_id]
  subnets                     = module.public_private_subnets.public_subnet_ids
  key_name                    = module.aws_key_pair.key_name
  vpc_id                      = module.vpc.vpc_id
  associate_public_ip_address = local.bastion.associate_public_ip_address

  context = module.bastion_label.context
}