data "aws_vpc" "primary" {
  filter {
    name   = "tag:Name"
    values = ["${local.namespace}-${local.stage}-${local.name}-vpc"]
  }
}

# Directly filter subnets by both VPC ID and tag
data "aws_subnets" "private_only_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.primary.id]
  }
  
  filter {
    name   = "tag:Attributes"
    values = ["private-only-private"]
  }
}

# Get detailed information
data "aws_subnet" "private_subnet_details" {
  for_each = toset(data.aws_subnets.private_only_subnets.ids)
  id       = each.key
}

data "aws_security_group" "db_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.namespace}-${local.stage}-${local.name}-${local.db.name}"]
  }
}
