defmodule ShortieWeb.PageController do
  use ShortieWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
