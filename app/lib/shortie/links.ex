defmodule Shortie.Links do
  @moduledoc """
  The Links context.
  """

  import Ecto.Query, warn: false

  alias Shortie.Repo
  alias Shortie.Links.Link

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Returns the list of the 10 most recently created links. You can override the
  limit by providing your own limit.

  ## Examples

      iex> list_recent_links()
      [%Link{}, ...]

      iex> list_recent_links(15)
      [%Link{}, ...]
  """
  def list_recent_links(limit \\ 10) do
    # NOTE: Performance opportunity: offload reading to a caching process if
    # limit is 10. Remember to invalidate/refresh cache on creation
    Repo.all(
      from l in Link,
      select: l,
      order_by: [desc: :inserted_at],
      limit: ^limit
    )
  end

  @doc """
  Gets a single link.

  Raises if the Link does not exist.

  ## Examples

      iex> get_link!("l_uc39ah")
      %Link{}

  """
  def get_link!(id), do: Repo.get!(Link, id)

  @doc """
  Resolve a link from a slug.

  ## Examples

      iex> resolve_link("uc39ah")
      {:ok, %Link{}}
  """
  def resolve_link(slug) do
    internal_id = << "l_", slug :: binary >>
    Repo.get(Link, internal_id)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"})
      {:ok, %Link{}}

      iex> create_link(%{field: "hptps:/ww.wat?abc123"})
      {:error, ...}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, ...}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

end
