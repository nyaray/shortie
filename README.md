# shortie

The world-wide meme-economy is exploding: time is money and we need to save time
on URLs, as we read them letter by letter to our friends over voice chat.

This is the world in which shortie was born.

## Requirements

Running shortie doesn't require much! The instructions assume that you're
running GNU/Linux, but macOS command equivalents should be easy to figure out.

To run shortie, you need to have
[Docker](https://www.docker.com/products/docker-desktop/alternatives) installed,
docker-engine will do, so don't worry about the slightly aggressive pitch from
Docker.

That's it, you're now ready to run `bootstrap.sh`! Go ahead, try it.

## Bootstrapping Your Environment

To prepare your environment for running shortie, having installed the
dependencies, you need to:

- Run `docker swarm init` , to create a local swarm where the shortie stack can be
  deployed. Don't worry if you've already done this at some point, Docker will
  tell you that you are in a swarm, which is fine.
- Create an environment file with your connection strings and secrets and name
  them `.env-dev` and `.env-prod`, respectively. They should look something like
  this (with `$ENV` replaced by either `dev` or `prod`):

      DATABASE_URL=ecto://postgres:postgres@db:5432/shortie_$ENV
      SECRET_KEY_BASE=APg847Y5Gs+DPry6bC5Sq4TOX1/RerRYbn56CTxYzofn2uDTw9TN7Ly/Qk2PJk00
      MIX_ENV=$ENV
      VIRTUAL_HOST=short.ie
  - You should generate your own secret key base, check out the development
    description later in this document to see how to do that.
- Run `bootstrap.sh` , to build docker images, setup the stack (the set of
  containers used to run the app, database and reverse proxy which acts as a
  gateway) as well as seeding the database.
  - Stacks are either deployed and trying to keep their services running or not
    existing, so the bootstrap script leaves a running environment behind if
    everything goes well.
  - Try running the bootstrap script again if it fails on the first try, docker
    might not always be able to bring up the containers fast enough for
    everything to go smoothly.
  - The reverse proxy lets you add more services without reconfiguring too much,
    new containers just need to have a `VIRTUAL_HOST` ENV variable to be picked
    up automagically.

## Running shortie

- To access shortie locally, while getting the full online-experience, run the following:
  `echo "127.0.0.1 short.ie" | sudo tee -a /etc/hosts`
  - If you don't want to use shortie in this way, you can change the
    `VIRTUAL_HOST` environment variable for shortie to `localhost` and connect
    to the application server by going to http://localhost instead.

To run shortie, run `./run.sh` from the project root-directory.

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

To generate your secret key base, run `mix phx.gen.secret` and copy/paste that
value into the file, once per environment. I've provided one for your
convenience, but it should not be used in production.

You should be able to source the `.env-dev` file you created earlier and fetch
the dependencies, compile them and the application itself, in order to be able
to run things and see that they work. It is a good idea to do each of the
following in the specified order the first time you try out the
code-test/test-code-run cycle, so that things are in place when they're needed.

    . .env-dev
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

To run the tests, you can do `mix test`. The following snippet relies on `watch`
to re-run the tests whenever code or a test is changed.

    (while true; do; watch -n1 -g 'git diff lib test | sha1sum' > /dev/null 2>&1 && if [ $? -eq 0 ]; then; echo "=== CHANGE DETECTED ==="; fi; done) | mix test --listen-on-stdin

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
