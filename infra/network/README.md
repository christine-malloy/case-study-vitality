# Vitality Network Infrastructure

> **Architecture Documentation**: For detailed architecture information, see the [Network Architecture Documentation](../../arch/network/).

This directory contains the Terraform configuration for deploying the AWS VPC and network components.

## Architecture

The network deployment consists of:

- **VPC**: Isolated network environment for all resources
- **Subnets**: Public, private, and database subnets across multiple AZs
- **Internet Gateway**: Provides internet access to public subnets
- **NAT Gateways**: Allow private subnet resources to access the internet
- **Route Tables**: Define traffic routing between subnets and gateways
- **Network ACLs**: Provide additional network security

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

### VPC

The VPC is configured with:
- CIDR block for IP address allocation
- DNS support and hostnames
- Flow logs for network monitoring

### Subnets

Three types of subnets are deployed:
- **Public Subnets**: For internet-facing resources (load balancers, bastion hosts)
- **Private Subnets**: For application services (App Runner, ECS, EC2)
- **Database Subnets**: For database instances (RDS, Aurora)

Each subnet type is deployed across multiple Availability Zones for high availability.

### Gateways and NAT

- **Internet Gateway**: Connects the VPC to the internet
- **NAT Gateways**: Allow private subnet resources to initiate outbound traffic
- **Route Tables**: Define how traffic flows between subnets and gateways

## Configuration

You can customize the deployment by modifying the `terraform.tfvars` file. Here are the available variables:

| Variable | Description | Default |
|----------|-------------|---------|
| namespace | Organization namespace | "vitality" |
| stage | Environment stage | "dev" |
| name | Network name | "app" |
| region | AWS region | "us-west-2" |
| vpc_cidr | VPC CIDR block | "10.0.0.0/16" |
| azs | Availability zones | ["us-west-2a", "us-west-2b", "us-west-2c"] |
| public_subnets | Public subnet CIDRs | ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] |
| private_subnets | Private subnet CIDRs | ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"] |
| database_subnets | Database subnet CIDRs | ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"] |
| enable_nat_gateway | Enable NAT gateways | true |
| single_nat_gateway | Use single NAT gateway | true |

## Outputs

| Output | Description |
|--------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| database_subnet_ids | List of database subnet IDs |
| database_subnet_group_name | Name of the database subnet group 