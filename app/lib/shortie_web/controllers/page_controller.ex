defmodule ShortieWeb.PageController do
  use ShortieWeb, :controller

  require Logger

  def index(conn, _params) do
    links = get_recent_links(conn)
    conn
    |> render_index(links: links)
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
    |> Enum.map(fn l -> externalise_link(conn, l) end)
  end

  #
  # Internals
  #

  defp render_index(conn, params) do
    # ensure that there is a changeset present for the form to render
    params = Keyword.put_new(params, :changeset, Shortie.Links.Link.empty_changeset())

    render(conn, "index.html", params)
  end

  defp externalise_link(conn, %Shortie.Links.Link{ id: id, inserted_at: inserted_at, url: url }) do
    external_id = Shortie.Links.Link.external_id(id)
    external_url = Routes.page_url(conn, :resolve, external_id)

    %{
      id: external_id,
      inserted_at: inserted_at,
      page_url: external_url,
      target_url: url
    }
  end

end
