defmodule ShortieWeb.PageController do
  use ShortieWeb, :controller

  require Logger

  def index(conn, _params) do
    links = get_recent_links(conn)
    render_index(conn, links: links)
  end

  def create(conn, params) do
    case insert_link(params) do
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
    case resolve_link(params) do
      nil ->
        conn
        |> put_flash(:info, "Invalid link!")
        |> redirect(to: "/")
      link ->
        redirect(conn, external: link.url)
    end
  end

  #
  # Saving links
  #

  defp insert_link(params) do
    params
    |> params_to_link_changeset()
    |> Shortie.Repo.insert()
  end

  defp params_to_link_changeset(params) do
    Shortie.Link.changeset(
      %Shortie.Link{},
      Map.get(params, "link", %{})
    )
  end

  #
  # Listing links
  #

  defp get_recent_links(conn) do
    Shortie.Repo.get_recent_links()
    |> Enum.map(fn l -> %{ id: l.id, inserted_at: l.inserted_at, target_url: l.url } end)
    |> Enum.map(fn l -> add_page_url(conn, l) end)
  end

  defp add_page_url(conn, link) do
    eid = external_id(link.id)
    eurl = external_url(conn, eid)

    Map.put link, :page_url, eurl
  end

  #
  # Resolving
  #

  defp resolve_link(params) do
    internal_id = << "l_", params["slug"] :: binary >>
    Shortie.Repo.get(Shortie.Link, internal_id)
  end

  #
  # Internals
  #

  defp render_index(conn, params) do
    # guarantee defaults for the template
    params = Keyword.put_new(params, :changeset, Ecto.Changeset.cast(%Shortie.Link{}, %{}, []))

    render(conn, "index.html", params)
  end

  defp externalise_link(conn, %Shortie.Link{ id: id, inserted_at: inserted_at, url: url }) do
    external_id = external_id(id)

    %{
      id: external_id,
      inserted_at: inserted_at,
      page_url: external_url(conn, external_id),
      target_url: url
    }
  end

  defp external_id(link_id), do: Shortie.Link.external_id(link_id)
  defp external_url(conn, external_id), do: Routes.page_url(conn, :resolve, external_id)

end
