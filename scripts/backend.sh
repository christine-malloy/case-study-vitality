#!/bin/bash
cd "$(dirname "$0")/../deployment"
docker compose down -v
docker compose up --build --force-recreate --remove-orphans