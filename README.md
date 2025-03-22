# Case Study: Vitality

This project contains a full-stack application with a Bun backend and a Next.js frontend application deployed on AWS infrastructure.

## Prerequisites

- [Docker](https://www.docker.com/get-started) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Node.js](https://nodejs.org/) (for frontend development)
- [Bun](https://bun.sh/) (for API development)
- [Terraform](https://www.terraform.io/downloads) (for infrastructure management)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with appropriate credentials)

## Project Structure

### Application Code
- [`/api`](./api/) - Bun.js backend API server
- [`/frontend`](./frontend/) - Next.js frontend application

### Infrastructure
- [`/infra`](./infra/) - Infrastructure as code (Terraform)
  - [`/infra/api`](./infra/api/) - API App Runner service configuration
  - [`/infra/db`](./infra/db/) - Aurora PostgreSQL database configuration
  - [`/infra/network`](./infra/network/) - VPC, subnets, and security groups
  - [`/infra/registry`](./infra/registry/) - ECR container registry configuration
  - [`/infra/frontend`](./infra/frontend/) - S3, CloudFront, and WAF configuration

### Architecture Documentation
- [`/arch`](./arch/) - Architecture documentation
  - [`/arch/api`](./arch/api/) - API architecture documentation
  - [`/arch/db`](./arch/db/) - Database architecture documentation
  - [`/arch/frontend`](./arch/frontend/) - Frontend architecture documentation
  - [`/arch/network`](./arch/network/) - Network architecture documentation
  - [`/arch/registry`](./arch/registry/) - Container registry architecture documentation

### Overall Architecture Plan
- [`/arch-plan.md`](./arch-plan.md) - High-level architecture overview focusing on Aurora, CloudWatch, and Security Hub

### Local Development Setup

For local development, you can use Docker Compose to run the API and database:

```bash
cd ./deployment
docker-compose up -d
```

The API will be available at http://localhost:3001

Alternatively, you can use the provided scripts:

1. Start the backend:
   ```bash
   ./scripts/backend.sh
   ```
2. In a separate terminal, start the frontend:
   ```bash
   ./scripts/frontend.sh
   ```

## Running Tests

Running the test suite is a critical part of the development workflow. The project includes comprehensive tests to verify functionality and catch regressions.

### Integration Tests

To run the integration tests:

```bash
./scripts/test.sh
```

This script:
1. Starts the necessary services using Docker Compose
2. Waits for the server to become available
3. Runs the integration test suite against the running services
4. Cleans up by stopping the containers after tests complete

## Available Scripts

The project includes several scripts to help manage the development environment:

### Backend Development

```bash
./scripts/backend.sh
```
This script:
- Stops any running containers
- Rebuilds and starts the backend services using Docker Compose
- Includes the database and API server

### Frontend Development

```bash
./scripts/frontend.sh
```
This script:
- Starts the frontend development server
- Uses Bun to run the development environment

### Running Tests

```bash
./scripts/test.sh
```
This script:
- Starts the Docker Compose stack
- Waits for the server to be available
- Runs the integration tests
- Cleans up by stopping the containers after tests complete

### Building and Pushing API Container

```bash
./api/build_and_push.sh
```
This script:
- Builds the API Docker container
- Tags it appropriately
- Pushes it to the ECR repository

## Deployment

### Infrastructure Deployment

To deploy the infrastructure components:

1. Navigate to the desired infrastructure directory:
   ```bash
   cd infra/network
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Repeat for each infrastructure component in the following order:
   - network
   - db
   - registry
   - api
   - frontend

### Frontend Deployment

After the infrastructure is deployed:

1. Build the frontend application:
   ```bash
   cd frontend
   bun run build
   ```

2. Deploy to S3 using the deployment script:
   ```bash
   cd infra/frontend
   ./deploy.sh
   ```

### API Deployment

1. Build and push the API container:
   ```bash
   cd api
   ./build_and_push.sh
   ```

2. The App Runner service will automatically deploy the latest container image.

## Architecture Overview

For a high-level overview of the system architecture, see the [Architecture Plan](./arch-plan.md).

Detailed architecture documentation is available for each component:

- [API Architecture](./arch/api/)
- [Database Architecture](./arch/db/)
- [Frontend Architecture](./arch/frontend/)
- [Network Architecture](./arch/network/)
- [Registry Architecture](./arch/registry/)

## Case Study Focus Areas
Our problem case states the following issues with the system:
- **Database Connection Issues**: How can we resolve persistent connection pool exhaustion and dropped connections?
- **Server Memory Leaks**: What's causing the gradual memory consumption increase that requires frequent server restarts?

We have unanswered questions around the following technical areas:
- **Clustering solution**: How can we effectively distribute workloads across multiple servers?
- **Observability plan**: How should we implement comprehensive monitoring and logging?
- **Soc2 compliancancy**: What security and privacy controls are needed for customer data protection?
- **Cloud strategy**: What is the best approach for leveraging cloud services and infrastructure?

Our proposed solution is:
- **Cloud Architecture Plan**: Comprehensive AWS-based architecture with App Runner, Aurora, and CloudFront
- **Compute and Data Solution**: Aurora PostgreSQL for database clustering and App Runner for application scaling
- **Observability Plan**: CloudWatch for metrics, logs, and alarms
- **SOC2 Compliance**: Security Hub for compliance monitoring and reporting

Below is a summary of our case study, solutions forward, and an organized roadmap:

- [Current State Analysis](./current-state-analysis.md)
- [Proposed Solutions](./proposed-solutions.md)
- [Implementation RoadMap](./implementation-roadmap.md)

For further detail, please review facets of focus:

### [Architecture Plan](./arch-plan.md)
Details of the system architecture design and implementation plan.

### [Database Connection Issues](./db-connection-issues.md)
Documentation of database connection issues encountered and their solutions.

### [Memory Leak Issues](./memory-leak-issues.md)
Analysis and resolution of memory leak issues in the application.

### [Local Development Stack](./local-dev-stack.md)
Guide for setting up and using the local development environment.

### [Compute Solution Plan](./compute-solution-plan.md)
Strategy for implementing clustering to improve scalability and reliability.

### [SOC2 Compliance Plan](./soc2-compliance-plan.md)
Roadmap for achieving SOC2 compliance for the application.

### [Observability Plan](./observability-plan.md)
Implementation plan for monitoring, logging, and tracing solutions.