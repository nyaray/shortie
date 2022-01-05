# shortie

The world-wide meme-economy is exploding: time is money and we need to save time
on URLs, as we read them letter by letter to our friends over \<insert voice
chat here\> when discussing which \<overhyped pyramid scheme instance\> to right
click and `Save as` next.

This is the world in which shortie was born.

## Requirements

The instructions assume that you're running GNU/Linux, but macOS command
equivalents should be easy to figure out.

Running shortie doesn't require much!

To run shortie, you need to have
[Docker](https://www.docker.com/products/docker-desktop/alternatives) installed.

### Permissions

If you get errors about permissions when trying to run `bootstrap.sh` you might
need to add yourself to the group that owns the docker daemon socket file. Use
`ls -l <file>` on the file you're being denied access to in order to figure out
which group owns the socket. Then add yourself to that group with

    sudo usermod -a -G <groupname> <username>

you probably also want to grant yourself
read/write rights by running:

    sudo chmod 660 <file>

After this you either need to log out and back in again or to log in to the
newly added group by running `newgrp docker`. Note that you *might* need to
reboot for the change to take effect properly.

You should now be able to use `docker ps` to see that you may communicate with
the local docker service.

### Development

Developing shortie requires an [elixir
installation](https://elixir-lang.org/install.html) and it is strongly advised
that you use a version manager, such as ASDF-VM to manage it, since it allows
you to switch elixir version on a per-project basis. ASDF-VM can also handle
other languages and some tools, check it out!

The first thing you need to do is create an environment file with your
connection strings and secrets and name them `.env-dev` and `.env-prod`,
respectively. They should look something like this (with `$ENV` replaced by
either `dev` or `prod`):

    DATABASE_URL=ecto://postgres:postgres@db:5432/shortie_$ENV
    SECRET_KEY_BASE=YOUR_BIG_SECRET_HERE
    MIX_ENV=$ENV

To generate your secret key base, run `mix phx.gen.secret` and copy/paste that
value into the file, once per environment.

Now you should be able to source the environment file you just created and fetch
the dependencies, compile them and the application itself, in order to be able
to run things and see that they work. It is a good idea to do each of the
following in the specified order the first time you try out the
code-test/test-code-run cycle, so that things are in place when they're needed.

    . .env-$ENV
    cd app
    mix deps.get
    mix deps.compile
    mix compile
    mix ecto.setup
    mix test
    mix phx.server

You can run `mix ecto.setup` against your stack's database instance as the task
will default to the dev env and create a schema in the database. Once you've
done that you can enjoy hot reloading and other niceties one get's by running
`mix phx.server` to start the application in dev mode.

### Running in Development

When developing shortie, it is cumbersome to deal with docker images, containers
and the application stack if you're trying things out, but if you've deployed a
stack locally, you can re-use the database container.

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

- Run `docker swarm init` , to create a local swarm where the shortie stack can be
  deployed.
- Run `bootstrap.sh` , to build docker images, setup the stack and seed the database.
  - Stacks are either deployed and trying to keep their services running or not
    existing, so the bootstrap script leaves a running environment behind if
    everything goes well.
  - Try running the bootstrap script again if it fails on the first try, docker
    might not always be able to bring up the containers fast enough for
    everything to go smoothly.

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
