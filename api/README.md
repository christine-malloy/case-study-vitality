# Vitality API Service

This directory contains the Bun API server for the Vitality application.

## Local Development

### Prerequisites

- [Bun](https://bun.sh/) installed
- Docker installed (for containerization)
- AWS CLI configured with appropriate permissions

### Running Locally

1. Install dependencies:

```bash
bun install
```

2. Start the development server:

```bash
bun run index.ts
```

The server will start on port 3001. You can access it at http://localhost:3001.

## Building and Deploying to AWS

### Step 1: Build and Push Docker Image to ECR

Make the build script executable:

```bash
chmod +x build_and_push.sh
```

Run the build script:

```bash
./build_and_push.sh
```

This script will:
- Build the Docker image
- Tag the image
- Push it to your ECR repository

### Step 2: Deploy to AWS App Runner

Navigate to the Terraform infrastructure directory:

```bash
cd ../infra/api
```

Initialize Terraform:

```bash
terraform init
```

Apply the Terraform configuration:

```bash
terraform apply
```

This will deploy the API to AWS App Runner, connecting it to your VPC and database.

## API Endpoints

- `GET /`: Returns "Hello World"
- `GET /status`: Returns the server status, including uptime
- `GET /cars`: Returns a list of cars from the database

## Environment Variables

The API uses the following environment variables:

- `PORT`: The port to listen on (default: 3001)
- `DB_HOST`: PostgreSQL database host
- `DB_PORT`: PostgreSQL database port (default: 5432)
- `POSTGRES_DB`: PostgreSQL database name
- `POSTGRES_USER`: PostgreSQL username
- `POSTGRES_PASSWORD`: PostgreSQL password

These are automatically configured in the App Runner service when deployed to AWS.
