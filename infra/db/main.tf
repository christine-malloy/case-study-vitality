locals {
  namespace = "vitality"
  stage     = "dev"
  name      = "app"

  private_only_subnet_details = [
    for subnet in data.aws_subnet.private_subnet_details : {
      subnet_id         = subnet.id
      cidr_block        = subnet.cidr_block
      availability_zone = subnet.availability_zone
      tags              = subnet.tags
    }
  ]

  db = {
    name           = "postgres"
    instance_type  = "db.r6g.large"
    engine         = "aurora-postgresql"
    cluster_family = "aurora-postgresql16"
    admin_user     = "admin1"
    admin_password = "Test123456789" # never check this sort of thing into source control, this is only for demo purposes
    db_name        = "dbname"
    db_port        = 5432
    # 1 writer for dev, will scale to 1 writer and 1 reader in prod
    cluster_size = 1
  }
}

module "rds_cluster_aurora_postgres" {
  source = "cloudposse/rds-cluster/aws"

  name            = local.db.name
  context         = module.this.context
  engine          = local.db.engine
  cluster_family  = local.db.cluster_family
  cluster_size    = local.db.cluster_size
  namespace       = local.namespace
  stage           = local.stage
  admin_user      = local.db.admin_user
  admin_password  = local.db.admin_password
  db_name         = local.db.db_name
  db_port         = local.db.db_port
  instance_type   = local.db.instance_type
  vpc_id          = data.aws_vpc.primary.id
  security_groups = [data.aws_security_group.db_sg.id]
  subnets         = local.private_only_subnet_details[*].subnet_id
}