ARG BUILDER_IMAGE="hexpm/elixir:1.13.1-erlang-24.2-debian-bullseye-20210902-slim"
FROM ${BUILDER_IMAGE} as builder

# install build dependencies
RUN apt-get update -y \
    && apt-get install -y build-essential git \
    && apt-get clean \
    && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

