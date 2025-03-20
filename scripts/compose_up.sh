#!/bin/bash

# Change to the deployment directory
cd "$(dirname "$0")/../deployment"

# Run docker compose up
docker compose up 