# Vitality Container Registry Infrastructure

This directory contains the Terraform configuration for deploying the Amazon ECR registry for container images.

## Architecture

The registry deployment consists of:

- **ECR Repository**: Private Docker container registry
- **Repository Policy**: Controls access to the repository
- **Lifecycle Policy**: Manages image retention and cleanup

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

### ECR Repository

The ECR repository is configured with:
- Image scanning on push to identify vulnerabilities
- Image encryption for security
- Immutable tags to prevent overwriting existing images

### Lifecycle Policy

The lifecycle policy helps manage the repository by:
- Retaining a specified number of images per tag
- Automatically expiring untagged images after a period
- Cleaning up old images based on defined rules

## Configuration

You can customize the deployment by modifying the `terraform.tfvars` file. Here are the available variables:

| Variable | Description | Default |
|----------|-------------|---------|
| namespace | Organization namespace | "vitality" |
| stage | Environment stage | "dev" |
| name | Repository name | "app" |
| region | AWS region | "us-west-2" |
| image_tag_mutability | Image tag mutability | "IMMUTABLE" |
| scan_on_push | Scan images on push | true |
| max_image_count | Maximum number of images to keep | 100 |
| protected_tags | List of tags to protect from deletion | ["latest", "production"] |

## Outputs

| Output | Description |
|--------|-------------|
| repository_url | The URL of the ECR repository |
| repository_name | The name of the ECR repository |
| repository_arn | The ARN of the ECR repository |

## Usage

To push images to the repository:

```bash
# Log in to the ECR repository
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-west-2.amazonaws.com

# Tag your image
docker tag your-image:latest $(terraform output -raw repository_url):latest

# Push the image
docker push $(terraform output -raw repository_url):latest
``` 