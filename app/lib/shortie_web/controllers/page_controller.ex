defmodule ShortieWeb.PageController do
  use ShortieWeb, :controller

  require Logger

  def index(conn, _params) do
    links = get_recent_links(conn)
    render_index(conn, links: links)
  end

  def create(conn, params) do
    case Shortie.Links.create_link(params["link"]) do
      {:error, changes} ->
        links = get_recent_links(conn)
        render_index(conn, changeset: changes, links: links)
      {:ok, saved_link} ->
        externalised_link = externalise_link(conn, saved_link)
        links = get_recent_links(conn)
        render_index(conn, saved_link: externalised_link, links: links)
    end
  end

  def resolve(conn, params) do
    case Shortie.Links.resolve_link(params["slug"]) do
      nil ->
        conn
        |> put_flash(:info, "Invalid link!")
        |> redirect(to: "/")
      link ->
        redirect(conn, external: link.url)
    end
  end

  #
  # Listing links
  #

  defp get_recent_links(conn) do
    Shortie.Links.list_recent_links()
    |> Enum.map(fn l -> %{ id: l.id, inserted_at: l.inserted_at, target_url: l.url } end)
    |> Enum.map(fn l -> add_page_url(conn, l) end)
  end

  defp add_page_url(conn, link) do
    eid = external_id(link.id)
    eurl = external_url(conn, eid)

    Map.put link, :page_url, eurl
  end

  #
  # Internals
  #

  defp render_index(conn, params) do
    # guarantee defaults for the template
    # TODO: consider moving to context under a function named `empty` or similar?
    params = Keyword.put_new(params, :changeset, Ecto.Changeset.cast(%Shortie.Links.Link{}, %{}, []))

    render(conn, "index.html", params)
  end

  defp externalise_link(conn, %Shortie.Links.Link{ id: id, inserted_at: inserted_at, url: url }) do
    external_id = external_id(id)

    %{
      id: external_id,
      inserted_at: inserted_at,
      page_url: external_url(conn, external_id),
      target_url: url
    }
  end

  defp external_id(link_id), do: Shortie.Links.Link.external_id(link_id)
  defp external_url(conn, external_id), do: Routes.page_url(conn, :resolve, external_id)

end
