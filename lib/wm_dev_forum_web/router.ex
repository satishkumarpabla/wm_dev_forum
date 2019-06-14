defmodule WmDevForumWeb.Router do
  use WmDevForumWeb, :router
  import WmDevForumWeb.VerifyUser

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :verify do
    plug(:verify_user)
  end

  scope "/auth", WmDevForumWeb do
    pipe_through(:browser)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end

  scope "/", WmDevForumWeb do
    # Use the default browser stack
    pipe_through(:browser)
    pipe_through(:verify)

    get("/registerations/new", PageController, :register)
    post("/registerations/create", PageController, :create_user)

    post("/add_question", PageController, :add_question)
    get("/question", PageController, :question)
    get("/approve_user", PageController, :approve_user)
    get("/delete_user", PageController, :delete_user)

    get("/question/:question_uuid/answers", PageController, :get_answers)
    post("/add_answer", PageController, :add_answer)
  end

  scope "/", WmDevForumWeb do
    # Use the default browser stack
    pipe_through(:browser)
    post("/login_user", PageController, :login_user)
    get("/logout", PageController, :logout)
    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WmDevForumWeb do
  #   pipe_through :api
  # end
end
