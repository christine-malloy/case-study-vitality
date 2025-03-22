#!/bin/bash

# Configuration
REGION="us-west-2"  # Change to your preferred AWS region
NAMESPACE="vitality"
STAGE="dev"
NAME="app"
ECR_REPO="${NAMESPACE}-${STAGE}-${NAME}"

# Login to ECR
echo "Logging in to Amazon ECR..."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.$REGION.amazonaws.com

# Get the repository URI
REPOSITORY_URI=$(aws ecr describe-repositories --repository-names $ECR_REPO --query "repositories[0].repositoryUri" --output text)

if [ $? -ne 0 ]; then
  echo "Repository not found. Make sure you have run terraform apply in the infra/registry directory first."
  exit 1
fi

# Build the Docker image
echo "Building the Docker image..."
docker build -t $ECR_REPO:latest .

if [ $? -ne 0 ]; then
  echo "Docker build failed."
  exit 1
fi

# Tag the image
echo "Tagging the image..."
docker tag $ECR_REPO:latest $REPOSITORY_URI:latest

# Push the image to ECR
echo "Pushing the image to ECR..."
docker push $REPOSITORY_URI:latest

echo "Image successfully pushed to ECR: $REPOSITORY_URI:latest"
echo "You can now run terraform apply in the infra/api directory to deploy the App Runner service." 