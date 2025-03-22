# Vitality Database Infrastructure

> **Architecture Documentation**: For detailed architecture information, see the [Database Architecture Documentation](../../arch/db/).

This directory contains the Terraform configuration for deploying the Aurora PostgreSQL database on AWS.

## Architecture

The database deployment consists of:

- **Aurora PostgreSQL Cluster**: Managed PostgreSQL-compatible database
- **DB Instance**: Database compute instance running in the cluster
- **Security Group**: Controls access to the database
- **Subnet Group**: Configures which subnets the database can use
- **Parameter Group**: Customizes database settings

## Deployment Process

1. **Configure Variables**:

```bash
# Copy the example variables file
cp terraform.tfvars.example terraform.tfvars

# Edit the variables as needed
nano terraform.tfvars
```

2. **Setup Infrastructure**:

```bash
# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply changes
terraform apply
```

## Infrastructure Components

### Aurora PostgreSQL Cluster

The Aurora PostgreSQL cluster is configured with:
- Single writer instance for development
- Database name, username, and password
- Automated backups for data protection
- Storage encryption for security

### Security Groups

Security groups control:
- Inbound access to PostgreSQL port (5432) 
- Limit access to specific security groups and CIDRs
- Prevent unauthorized access

### Subnet Groups

Subnet groups determine:
- Which VPC subnets the database can use
- Network isolation level
- High availability configuration

## Configuration

You can customize the deployment by modifying the `terraform.tfvars` file. Here are the available variables:

| Variable | Description | Default |
|----------|-------------|---------|
| namespace | Organization namespace | "vitality" |
| stage | Environment stage | "dev" |
| name | Database name prefix | "postgres" |
| region | AWS region | "us-west-2" |
| vpc_id | VPC ID | "" |
| subnet_ids | List of subnet IDs | [] |
| instance_type | Database instance type | "db.r6g.large" |
| engine_version | Aurora PostgreSQL version | "13.9" |
| db_name | Database name | "vitality" |
| db_admin_user | Database admin username | "postgres" |
| db_admin_password | Database admin password | "change_me" |
| deletion_protection | Enable deletion protection | true |

## Outputs

| Output | Description |
|--------|-------------|
| cluster_endpoint | The writer endpoint for the cluster |
| cluster_reader_endpoint | The reader endpoint for the cluster |
| cluster_id | The ID of the cluster |
| security_group_id | The ID of the security group |
| master_username | The master username for the database | 