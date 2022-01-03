defmodule Shortie.Repo do
  use Ecto.Repo,
    otp_app: :shortie,
    adapter: Ecto.Adapters.Postgres
end
