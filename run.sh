#!/usr/bin/env bash

# Halt on errors
set -e

# Get the ENVARS
set -o allexport
. .env-prod
set +o allexport

# Deploy the stack locally
docker stack deploy -c stack.yml shortie

# Give the stack, primarily the database, some time to go up
echo "Sleeping 5s to let database come up"
sleep 5s

# Create database, if needed.
cd app
export MIX_ENV=prod
export DATABASE_URL=ecto://postgres:postgres@localhost:5432/shortie_$MIX_ENV
mix ecto.setup
