# shortie

The world-wide meme-economy is exploding: time is money and we need to save time
on URLs, as we read them letter by letter to our friends over discord when
discussing which NFT to right click and download next.

This is the world in which shortie was born.

## Requirements

Running shortie doesn't require much!

To run shortie, you need to have
[Docker](https://www.docker.com/products/docker-desktop/alternatives) installed.

### Development

Developing shortie requires an [elixir
installation](https://elixir-lang.org/install.html) and it is strongly advised
that you use a version manager, such as ASDF-VM to manage it, since it allows
you to switch elixir version on a per-project basis. ASDF-VM can also handle
other languages and some tools, check it out!

Once you're ready to start working on shortie, `cd app`, to move into the
application directory.  You can run `mix ecto.setup` against your stack's
database instance as the task will default to the dev env and create a schema in
the database. Once you've done that you can enjoy hot reloading and other
niceties one get's by running `mix phx.server` to start the application in dev
mode.

### Testing

To run the tests, you can do `mix test`.

### What's Up With the Docker Files

The reason that there are several Dockerfiles in this project is to shorten
(re-)build-times and to avoid re-building base-images unnecessarily. They're
located in the `app` folder as they depend on the elixir project files. The
various files are used for the following purposes:

- **Dockerfile.builder (shortiebuilder)** A debian-based image that provides the
  most common build tools, relevant language runtimes, mix and rebar.
- **Dockerfile.runner (shortierunner)** A debian-based bare-minimum image used
  to run the built release.
- **Dockerfile (shortie)** The main image, which uses the previous dockerfiles
  as starting points for its build and run stages, respectively.
  - The builder stage is used as a target when creating the seeding image,
    `shortieseeder:local`, which is used to seed the database.

## Bootstrapping Your Environment

To prepare your environment for running shortie, having installed the
dependencies, you need to:

- Run `docker swarm init`, to create a local swarm where the shortie stack can be
  deployed.
- Run `bootstrap.sh`, to build docker images, setup the stack and seed the database.

## Running shortie

- To access shortie locally, to get the full online-experience, run the following:
  `echo "127.0.0.1 short.ie" | sudo tee -a /etc/hosts`
  - If you don't want to use shortie in this way, you can change the
    `VIRTUAL_HOST` environment variable for shortie in `stack.yml` to
    `localhost` and connect to the application server by going to
    http://localhost:8080 instead.

To run shortie, run `./run.sh` from the project root-directory.

Note that you might need to run `docker swarm init` to create a local swarm for
running the Docker stack used by this project if you don't already have swarm
set up.

### Running in Development

When developing shortie, it is cumbersome to deal with docker images, containers
and the application stack if you're trying things out, but if you've deployed a
stack locally, you can re-use the database container.
