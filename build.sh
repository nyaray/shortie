#!/usr/bin/env bash

# Halt on errors
set -e

# Get the ENVARS
set -o allexport
. .env-prod
set +o allexport

# Build builder image (`shortiebuilder`) to avoid repeating building it
docker build -f app/Dockerfile.builder app -t shortiebuilder

# Build runner image (`shortierunner`) to avoid repeating building it
docker build -f app/Dockerfile.runner app -t shortierunner

# Build app image (`shortie`)
docker image rm shortie
docker build -t shortie ./app