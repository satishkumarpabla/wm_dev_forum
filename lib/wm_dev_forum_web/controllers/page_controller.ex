defmodule WmDevForumWeb.PageController do
  use WmDevForumWeb, :controller
  alias WmDevForum.UserManagement
  alias WmDevForum.Schema.{User, Answer}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end

  def search_questions(conn, params) do
    # TODO: get from conn.assigns
    user_uuid = (conn.private.plug_session |> Map.get("user")).uuid

    search_results =
      UserManagement.get_search_results(params |> Map.get("search_tags"), user_uuid)
      |> IO.inspect(label: "222222222222")

    user_stats = get_user_stats(user_uuid)
    questions = UserManagement.get_questions()

    render(conn, "search-results-page.html", %{
      questions: questions,
      user_stats: user_stats,
      search_results: search_results,
      my_questions: false,
      search_query: params |> Map.get("search_tags")
    })
  end

  def create_user(conn, params) do
    case UserManagement.create_user(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("You have been registered!!!!"))
        |> redirect(to: page_path(conn, :register))

      {:error, changeset} ->
        errors =
          changeset.errors
          |> Enum.map(fn {key, {msg, _}} ->
            {key, msg}
          end)

        conn
        |> put_flash(:error, gettext("Could not register!"))
        |> Map.put(:errors, errors)
        |> redirect(to: page_path(conn, :register))
    end
  end

  def dashboard(conn, _params) do
    questions = UserManagement.get_questions()

    user_stats = UserManagement.get_user_stats(conn.assigns.user.uuid)

    conn
    |> render("dashboard.html", %{
      questions: questions,
      user_stats: user_stats,
      my_questions: false
    })
  end

  defp get_all_users(conn) do
    users = UserManagement.get_all_users()

    render(conn, "admin-dashboard.html", users: users)
    # render(conn, "index.html")
  end

  def get_all_questions(conn, _p) do
    loggedin_user =
      conn
      |> get_session(:user)

    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(loggedin_user.uuid)

    render(conn, "dashboard.html",
      questions: questions,
      user_stats: user_stats,
      my_questions: false
    )
  end

  def get_my_questions(conn, _p) do
    loggedin_user =
      conn
      |> get_session(:user)

    questions = UserManagement.get_questions_by_user(loggedin_user.uuid)
    user_stats = UserManagement.get_user_stats(loggedin_user.uuid)

    render(conn, "dashboard.html",
      questions: questions,
      user_stats: user_stats,
      my_questions: true
    )
  end

  def question(conn, _param) do
    question_tags = UserManagement.getTags()
    render(conn, "add-question.html", tags: question_tags)
  end

  def add_question(conn, params) do
    question_text = params |> Map.get("question_text")

    loggedin_user =
      conn
      |> get_session(:user)

    UserManagement.post_question(params, loggedin_user)
    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(loggedin_user.uuid)
    # redirect user to dashboard after adding question

    render(conn, "dashboard.html",
      questions: questions,
      user_stats: user_stats,
      my_questions: false
    )
  end

  def login_user(conn, params) do
    entered_user_name = params |> Map.get("user_name")
    entered_password = params |> Map.get("password")

    user = UserManagement.login_user(entered_user_name, entered_password)

    case user do
      nil ->
        render(conn, "error-page.html")

      %User{is_admin: true} ->
        conn
        |> put_session(:user, user)
        |> get_all_users()

      %User{is_admin: false} ->
        # has been commented because it was causing an issue at the time of login
        # UserManagement.post_question(params, loggedin_user)
        questions = UserManagement.get_questions()
        user_stats = get_user_stats(user.uuid)

        conn
        |> put_session(:user, user)
        |> render("dashboard.html", %{
          questions: questions,
          user_stats: user_stats,
          my_questions: false
        })

      _ ->
        render(conn, "error-page.html")
    end
  end

  def get_user_stats(user_uuid) do
    UserManagement.get_user_stats(user_uuid)
  end

  def approve_user(conn, params) do
    user_name = (params |> Map.get("first_name")) <> " " <> (params |> Map.get("last_name"))

    case UserManagement.approve_user(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("User {%user_name} Successfully Approved."))

      {:error, _} ->
        conn
        |> put_flash(:info, gettext("Unable to approve user."))
    end

    get_all_users(conn)
  end

  def get_answers(conn, params) do
    answers = UserManagement.get_answers_by_question_uuid(Map.get(params, "question_uuid"))

    question = UserManagement.get_question_by_uuid(Map.get(params, "question_uuid"))
    render(conn, "answers.html", answers: answers, question: question)
  end

  def add_answer(conn, params) do
    user_uuid = conn |> get_session(:user) |> Map.get(:uuid)

    UserManagement.add_answer(params["question_uuid"], user_uuid, params["answer"])

    answers = UserManagement.get_answers_by_question_uuid(Map.get(params, "question_uuid"))
    question = UserManagement.get_question_by_uuid(Map.get(params, "question_uuid"))

    conn
    |> redirect(to: page_path(conn, :get_answers, params["question_uuid"]))
  end

  def logout(conn, params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end

  def mark_correct_answer(
        conn,
        %{"answer_uuid" => answer_uuid} = _params
      ) do
    {:ok, %Answer{question_uuid: question_uuid}} = UserManagement.mark_correct_answer(answer_uuid)

    conn
    |> redirect(to: page_path(conn, :get_answers, question_uuid))
  end

  def add_vote(
        conn,
        %{
          "answer_uuid" => answer_uuid,
          "vote_type" => vote_type,
          "question_uuid" => question_uuid
        } = _params
      ) do
    user_uuid = conn.assigns.user.uuid

    UserManagement.add_vote(answer_uuid, user_uuid, vote_type)

    conn
    |> redirect(to: page_path(conn, :get_answers, question_uuid))
  end
end
