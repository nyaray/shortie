defmodule ShortieWeb.Router do
  use ShortieWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ShortieWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ShortieWeb.Telemetry
    end
  end

 scope "/", ShortieWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:slug", PageController, :resolve

    post "/", PageController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShortieWeb do
  #   pipe_through :api
  # end

end
