#!/bin/bash

# Exit on error
set -e

# Configuration
PROJECT_ROOT="../../frontend"
BUILD_DIR="$PROJECT_ROOT/.next"
OUTPUT_DIR="$PROJECT_ROOT/out"

# Get AWS region from Terraform outputs
echo "Getting AWS region from Terraform state..."
REGION=$(terraform output -json aws_region 2>/dev/null || echo '{"value":"us-west-2"}' | jq -r '.value')

# Get S3 bucket name
echo "Getting S3 bucket name from Terraform outputs..."
S3_BUCKET=$(terraform output -json s3_bucket_id | jq -r '.value')

if [ -z "$S3_BUCKET" ]; then
  echo "Error: Could not get S3 bucket name from Terraform outputs."
  echo "Make sure you have run 'terraform apply' first."
  exit 1
fi

# Get CloudFront distribution ID
echo "Getting CloudFront distribution ID from Terraform outputs..."
CF_DISTRIBUTION_ID=$(terraform output -json cloudfront_distribution_id | jq -r '.value')

if [ -z "$CF_DISTRIBUTION_ID" ]; then
  echo "Error: Could not get CloudFront distribution ID from Terraform outputs."
  echo "Make sure you have run 'terraform apply' first."
  exit 1
fi

# Build the Next.js app
echo "Building the Next.js app..."
cd $PROJECT_ROOT
npm run build

# Export the app to static HTML
echo "Exporting the app to static HTML..."
npx next export

# Sync the build directory to S3
echo "Syncing the build directory to S3..."
aws s3 sync $OUTPUT_DIR s3://$S3_BUCKET --delete --region $REGION

# Invalidate CloudFront cache
echo "Invalidating CloudFront cache..."
aws cloudfront create-invalidation --distribution-id $CF_DISTRIBUTION_ID --paths "/*" --region $REGION

echo "Deployment completed successfully!"
echo "Your app is available at: https://$(terraform output -json cloudfront_distribution_domain_name | jq -r '.value')" 