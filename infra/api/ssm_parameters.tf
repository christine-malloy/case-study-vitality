# SSM Parameters for database credentials
# These parameters store sensitive information securely
# In production, you should use AWS Secrets Manager for better security

locals {
  namespace        = "vitality"
  stage            = "dev"
  db_admin_user    = "postgres"
  db_admin_password = "postgres_password" # In production, use a secure method to set this
  db_name          = "vitality"
  db_port          = 5432
}

# Get RDS instance information
data "aws_rds_cluster" "postgres" {
  cluster_identifier = "${local.namespace}-${local.stage}-postgres"
}

# Store database connection details in Parameter Store
# Note: For production use AWS Secrets Manager instead of SSM Parameter Store
resource "aws_ssm_parameter" "db_host" {
  name        = "/${local.namespace}/${local.stage}/db/host"
  description = "Database host endpoint"
  type        = "String"
  value       = data.aws_rds_cluster.postgres.endpoint
  
  tags = {
    Namespace = local.namespace
    Stage     = local.stage
    Name      = "db-host"
  }
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/${local.namespace}/${local.stage}/db/user"
  description = "Database username"
  type        = "String"
  value       = local.db_admin_user
  
  tags = {
    Namespace = local.namespace
    Stage     = local.stage
    Name      = "db-user"
  }
}

resource "aws_ssm_parameter" "db_password" {
  name        = "/${local.namespace}/${local.stage}/db/password"
  description = "Database password"
  type        = "SecureString"
  value       = local.db_admin_password
  
  lifecycle {
    ignore_changes = [value]
  }
  
  tags = {
    Namespace = local.namespace
    Stage     = local.stage
    Name      = "db-password"
  }
}

# Add database configuration to locals
locals {
  db = {
    admin_user     = "admin1"      # Should match the value in infra/db/main.tf
    admin_password = "Test123456789" # Should match the value in infra/db/main.tf
    db_name        = "dbname"      # Should match the value in infra/db/main.tf
    db_port        = 5432          # Should match the value in infra/db/main.tf
  }
} 