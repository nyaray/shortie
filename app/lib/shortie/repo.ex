defmodule Shortie.Repo do
  use Ecto.Repo,
    otp_app: :shortie,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  def get_recent_links(limit \\ 10) do
    # TODO: offload this to a caching process, successful inserts trigger cache updates
    all(
      from l in Shortie.Link,
      select: l,
      order_by: [desc: :inserted_at],
      limit: ^limit
    )
  end

end
