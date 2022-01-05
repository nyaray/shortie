#!/usr/bin/env bash

# Halt on errors
set -e

# Get the ENVARS
set -o allexport
. .env-prod
set +o allexport

# Deploy the stack locally
docker stack up -c stack.yml shortie
