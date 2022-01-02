defmodule Shortie.Repo.Migrations.AddLinkIndex do
  use Ecto.Migration

  def change do
    create index("links", [:inserted_at])
  end
end
