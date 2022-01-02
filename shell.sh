#!/usr/bin/env bash

# Halt on errors
set -e

docker exec -it $(docker ps -q -f name=shortie_shortie) bin/shortie remote