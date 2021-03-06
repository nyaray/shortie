#!/usr/bin/env bash

# Halt on errors
set -e

# Get the ENVARS
set -o allexport
. .env-prod
set +o allexport

# Build app image (`shortie`)
docker image rm shortie:local
docker build -t shortie:local ./app