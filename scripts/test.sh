#!/bin/bash

cd "$(dirname "$0")/../api"

docker compose -f ../deployment/docker-compose.yml up -d --remove-orphans

# wait for server to be live
function wait_for_server() {
  until curl -s http://localhost:3001/status > /dev/null; do
    echo "Waiting for server to be up..."
    sleep 2
  done
}

wait_for_server

bun run int_test

docker compose -f ../deployment/docker-compose.yml down