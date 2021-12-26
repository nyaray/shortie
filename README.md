# shortie

The world-wide meme-economy is exploding: time is money and we need to save time
on URLs, as we read them letter by letter to our friends over voice chat.

This is the world in which shortie was born.

## Requirements

To run shortie, you need to have
[Docker](https://www.docker.com/products/docker-desktop/alternatives) installed.
<!--In order to also run shortie's dependencies you will be needing [Docker
Compose](https://docs.docker.com/compose/install/#prerequisites), which
coordinates starting up shortie and its dependencies.-->

### Developing locally

If you want to run things in your native OS environment, we suggest that you use
[ASDF to install and manage your language
versions](https://elixir-lang.org/install.html#compiling-with-version-managers)
as it can be somewhat tedious to do so manually, over time.

## Building

To run locally, you can `cd` into the top-level `app` directory of the project
and run `docker build -t shortie .`, which will build and register the docker
image locally. To run it, `cd` back to the project-top level and run `docker
stack deploy -c stack.yml shortie`. Note that you might need to run `docker
swarm init` to create a local swarm for running the Docker stack used by this
project.

That's it! You're ready to save time and share memes and important links quickly!

## Running shortie

Now that you've built your image you can run it with `docker run -d -p 1337:4000
shortie` to serve up the shortie page on port 1337 on any network interface you
might have on your system. Note that you can change 1337 to whatever you want,
but that you'll need to be root (on UNIX-like systems) to be able to bind to
ports in the 1-1023 range.
