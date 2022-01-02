defmodule Shortie.Repo.Migrations.AddLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string, null: false, size: Shortie.Link.max_length

      timestamps([type: :utc_datetime_usec])
    end
  end
end
