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

    get "/", PageController, :index

    get("/admin/get_all_users", PageController, :get_all_users)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WmDevForumWeb do
  #   pipe_through :api
  # end
end
