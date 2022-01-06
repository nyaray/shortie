#!/usr/bin/env bash

docker run \
    --rm \
    --network shortie_default \
    -it \
    --mount type=bind,source="$(pwd)"/app,target=/app \
    --link shortie_db \
    -e MIX_ENV=test \
    -e DATABASE_HOST=shortie_db \
    --mount type=bind,source="$(pwd)"/docker-build-test,target=/app/_build \
    shortiebuilder:local mix test
