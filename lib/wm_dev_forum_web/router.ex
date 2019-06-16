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

    get("/dashboard", PageController, :dashboard)
    post("/add_question", PageController, :add_question)
    get("/question", PageController, :question)
    get("/back_from_search_page", PageController, :back_from_search_page)
    get("/back_from_add_question_page", PageController, :back_from_add_question_page)
    get("/back_from_answers_page/:question_uuid", PageController, :back_from_answers_page)
    get("/back_from_login_page", PageController, :back_from_login_page)
    get("/myquestions", PageController, :get_my_questions)
    get("/allquestions", PageController, :get_all_questions)
    get("/approve_user", PageController, :approve_user)

    get("/question/:question_uuid/answers", PageController, :get_answers)
    post("/add_answer", PageController, :add_answer)
    post("/answer/:answer_uuid", PageController, :mark_correct_answer)

    post(
      "/question/:question_uuid/answer/:answer_uuid/vote/:vote_type",
      PageController,
      :add_vote
    )
  end

  scope "/", WmDevForumWeb do
    # Use the default browser stack
    pipe_through(:browser)
    post("/login_user", PageController, :login_user)
    post("/search_questions", PageController, :search_questions)
    get("/logout", PageController, :logout)
    get("/registerations/new", PageController, :register)
    post("/registerations/create", PageController, :create_user)

    get("/", PageController, :index)
  end

  # Other scopes may use custom stacks.
  # scope "/api", WmDevForumWeb do
  #   pipe_through :api
  # end
end
