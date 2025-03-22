# Vitality API Infrastructure

This directory contains the Terraform configuration for deploying the Bun.js API to AWS App Runner.

## Architecture

The API deployment consists of:

- **AWS App Runner**: Managed container service for running the API
- **VPC Connector**: Connects App Runner to the VPC private subnets
- **Security Groups**: Control traffic between App Runner and the database
- **IAM Role**: Allows App Runner to pull images from ECR
- **SSM Parameters**: Securely store database credentials

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

3. **Deploy API Application**:

```bash
# Go to the API directory
cd ../../api

# Build and push the Docker image
./build_and_push.sh
```

## Infrastructure Components

### AWS App Runner

The App Runner service is configured with:
- Container image from ECR
- VPC connectivity to access private resources
- Environment variables for database connection
- IAM role for ECR access

### VPC Connector

The VPC connector allows App Runner to:
- Connect to the database in private subnets
- Access other VPC resources securely
- Operate with proper network isolation

### Security Groups

Security groups control:
- Outbound access to the PostgreSQL database
- General internet access for dependencies

### SSM Parameters

Sensitive configuration is stored in SSM:
- Database hostname
- Database username
- Database password (as SecureString)

## Configuration

You can customize the deployment by modifying the `terraform.tfvars` file. Here are the available variables:

| Variable | Description | Default |
|----------|-------------|---------|
| namespace | Organization namespace | "vitality" |
| stage | Environment stage | "dev" |
| name | Application name | "api" |
| region | AWS region | "us-west-2" |
| container_port | Container port | 3001 |
| db_name | Database name | "vitality" |
| db_port | Database port | 5432 |
| db_admin_user | Database admin username | "postgres" |
| db_admin_password | Database admin password | "postgres_password" |

## Outputs

| Output | Description |
|--------|-------------|
| app_runner_service_url | The URL of the deployed App Runner service |
| app_runner_service_id | The ID of the App Runner service |
| app_runner_service_arn | The ARN of the App Runner service |
| vpc_connector_arn | The ARN of the VPC connector | 