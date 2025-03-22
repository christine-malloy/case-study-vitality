# Case Study: Vitality

This project contains a full-stack application with a Bun backend and a frontend application.

## Prerequisites

- Docker and Docker Compose
- Bun runtime
- Node.js (for frontend development)

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

## Project Structure

- `/api` - Backend API server
- `/frontend` - Frontend application
- `/deployment` - Docker Compose configuration
- `/scripts` - Utility scripts for development

## Getting Started

1. Clone the repository
2. Make the scripts executable:
   ```bash
   chmod +x scripts/*.sh
   ```
3. Start the backend:
   ```bash
   ./scripts/backend.sh
   ```
4. In a separate terminal, start the frontend:
   ```bash
   ./scripts/frontend.sh
   ```

## Running Tests

To run the integration tests:
```bash
./scripts/test.sh
```

This will start the necessary services, run the tests, and clean up afterward.

## Case Study

Our problem case states the following issues with the system:
- database connection issues
- server memory leaks

We have unanswered questions around the following technical areas:
- cloud architecture plan
- clustering solution
- observability plan
- soc2 compliancancy

Below is a summary of our case study, solutions forward, and an organized roadmap:

[Current State Analysis](./current-state-analysis.md)
[Proposed Solutions](./proposed-solutions.md)
[Implementation RoadMap](./implementation-roadmap.md)

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