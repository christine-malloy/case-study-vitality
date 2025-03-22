# Vitality API Architecture Summary

## Overview
The Vitality API is deployed using AWS App Runner, a fully managed container service that offers quick deployment, automatic scaling, and simplified operations. The API connects to an Amazon Aurora PostgreSQL database for data persistence and operates within the project's VPC for enhanced security.

## Key Components
- **AWS App Runner Service**: Managed container service running the Bun.js API
- **VPC Connector**: Links the App Runner service to the private subnets in the VPC
- **Security Groups**: Control traffic between the API and database
- **ECR Repository**: Stores the API's Docker container image
- **Environment Variables**: Securely provide database credentials and configuration

## Diagram Reference
For a detailed architecture diagram, see [api_architecture.md](api_architecture.md).

## Benefits
- **Simplified Operations**: No need to manage servers or container orchestration
- **Auto Scaling**: Automatically scales based on traffic
- **Cost Efficient**: Pay only for what you use, scales to zero when idle
- **Security**: VPC integration and security group controls for network isolation
- **Fast Deployment**: Quick deployments with automatic rollbacks

## Next Steps
- Implement CI/CD for automated build and deployment
- Set up custom domain with HTTPS
- Add authentication and authorization
- Enhance monitoring and alerting 