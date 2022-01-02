# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :shortie,
  env: Mix.env()

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures the endpoint
config :shortie, ShortieWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ShortieWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Shortie.PubSub,
  live_view: [signing_salt: "avHgzkcf"]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure repos
config :shortie,
  ecto_repos: [Shortie.Repo]

# Configure hashids into ecto for shorties
config :ecto_hashids,
  prefix_separator: "_",
  characters: "0123456789abcdefghjkmnpqrstvwxyz",
  salt: "3acad842-06c2-48a3-9851-e2f5675ac901",
  prefix_descriptions: %{
    l: Link
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
