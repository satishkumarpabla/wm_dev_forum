defmodule WmDevForumWeb.Router do
  use WmDevForumWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WmDevForumWeb do
    pipe_through :browser # Use the default browser stack
    get "/register", PageController, :register
    post "/register", PageController, :register_user

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", WmDevForumWeb do
  #   pipe_through :api
  # end
end
