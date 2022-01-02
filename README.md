# shortie

The world-wide meme-economy is exploding: time is money and we need to save time
on URLs, as we read them letter by letter to our friends over voice chat.

This is the world in which shortie was born.

## Requirements

To run shortie, you need to have
[Docker](https://www.docker.com/products/docker-desktop/alternatives) installed
as well as have set up a swarm, in order to run the stack of applications (the
app itself and the database used to store its data).

## Building

To build shortie you need to build two docker images and deploy a docker stack,
which you can do by running `./build.sh`. The docker stack will run shortie and
a postgres-instance for persistent storage.

## Running shortie

To run shortie, run `./run.sh` from the project root-directory.

Note that you might need to run `docker swarm init` to create a local swarm for
running the Docker stack used by this project if you don't already have swarm
set up.
