#!/usr/bin/env bash

# Halt on errors
set -e

# Get the ENVARS
set -o allexport
. .env-prod
set +o allexport

# Build runner image (`shortierunner`) to avoid repeating building the same
# thing for each environment
docker build -f app/Dockerfile.runner app -t shortierunner

# Build app image (`shortie`)
docker build -t shortie ./app