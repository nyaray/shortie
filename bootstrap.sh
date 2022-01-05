#!/usr/bin/env bash

# Halt on errors
set -e

# Get the ENVARS
set -o allexport
. .env-prod
set +o allexport

# Build builder image (`shortiebuilder`) to avoid repeating building it
docker build -f app/Dockerfile.builder app -t shortiebuilder:local

# Build runner image (`shortierunner`) to avoid repeating building it
docker build -f app/Dockerfile.runner app -t shortierunner:local

# Build app image
docker build app -t shortie:local

# Make directory to persist data across stack deployments
mkdir -p docker-postgres/db/data

# Deploy application stack
docker stack deploy -c stack.yml shortie

echo "Sleeping 15 seconds to let the postgres container start ..."

sleep 15

# expect/accept failures
set +e
docker exec -it $(docker ps -q -l -f name=shortie_db) pg_isready -t 0
POSTGRES_STATUS=$?
set -e

RETRIES=5
until [ $POSTGRES_STATUS -eq 0 ] || [ $RETRIES -eq 0 ]; do
  echo "Waiting for postgres container to become ready, $((RETRIES)) remaining attempts ..."
  RETRIES=$((RETRIES-=1)) 

  # expect/accept failures
  set +e
  docker exec -it $(docker ps -q -l -f name=shortie_db) pg_isready -t 0
  POSTGRES_STATUS=$?
  set -e

  sleep 5
done

# Build the seeder image and run the shortieseeder image in a temporary
# container connected to the shortie network
docker build -f app/Dockerfile app --target builder -t shortieseeder:local
# docker run --rm --network shortie_default --env-file .env-prod shortieseeder:local mix ecto.setup
docker run \
  --rm \
  --network shortie_default \
  --env-file .env-prod \
  shortieseeder:local \
  mix ecto.setup
