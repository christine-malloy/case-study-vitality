locals {
  namespace         = "vitality"
  stage             = "dev"
  name              = "api"
  vpc_connector_name = "${local.namespace}-${local.stage}-app-runner-connector"
  service_name      = "${local.namespace}-${local.stage}-api-service"
  container_port    = 3001
}

# Environment variables for the API service
locals {
  env_vars = [
    {
      name  = "PORT"
      value = tostring(local.container_port)
    },
    {
      name  = "DB_HOST"
      value = data.aws_ssm_parameter.db_host.value
    },
    {
      name  = "DB_PORT"
      value = "5432"
    },
    {
      name  = "POSTGRES_DB"
      value = local.db_name
    },
    {
      name  = "POSTGRES_USER"
      value = data.aws_ssm_parameter.db_user.value
    },
    {
      name  = "POSTGRES_PASSWORD"
      value = data.aws_ssm_parameter.db_password.value
    }
  ]
}

data "aws_vpc" "app_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${local.namespace}-${local.stage}-app-vpc"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.app_vpc.id]
  }

  filter {
    name   = "tag:Type"
    values = ["private"]
  }
}

data "aws_security_group" "db_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.namespace}-${local.stage}-postgres-sg"]
  }
}

data "aws_ecr_repository" "app_repo" {
  name = "${local.namespace}-${local.stage}-${local.name}"
}

resource "aws_security_group" "app_runner_sg" {
  name        = "${local.namespace}-${local.stage}-app-runner-sg"
  description = "Security group for App Runner service"
  vpc_id      = data.aws_vpc.app_vpc.id

  # Allow outbound connection to the database
  egress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.aws_security_group.db_sg.id]
  }

  # Allow outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${local.namespace}-${local.stage}-app-runner-sg"
    Namespace = local.namespace
    Stage     = local.stage
  }
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = local.vpc_connector_name
  subnets            = data.aws_subnets.private.ids
  security_groups    = [aws_security_group.app_runner_sg.id]

  tags = {
    Name      = local.vpc_connector_name
    Namespace = local.namespace
    Stage     = local.stage
  }
}

resource "aws_iam_role" "app_runner_role" {
  name = "${local.namespace}-${local.stage}-app-runner-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name      = "${local.namespace}-${local.stage}-app-runner-role"
    Namespace = local.namespace
    Stage     = local.stage
  }
}

resource "aws_iam_role_policy_attachment" "app_runner_ecr_policy" {
  role       = aws_iam_role.app_runner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_apprunner_service" "service" {
  service_name = local.service_name

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_role.arn
    }

    image_repository {
      image_identifier      = "${data.aws_ecr_repository.app_repo.repository_url}:latest"
      image_repository_type = "ECR"
      image_configuration {
        port = local.container_port
        runtime_environment_variables = {
          for env in local.env_vars : env.name => env.value
        }
      }
    }
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }

  tags = {
    Name      = local.service_name
    Namespace = local.namespace
    Stage     = local.stage
  }
}
