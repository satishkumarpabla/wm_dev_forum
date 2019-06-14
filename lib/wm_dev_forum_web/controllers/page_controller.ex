defmodule WmDevForumWeb.PageController do
  use WmDevForumWeb, :controller
  alias WmDevForum.UserManagement
  alias WmDevForum.Schema.User

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, _params) do
    render(conn, "register.html")
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

  defp get_all_users(conn) do
    users = UserManagement.get_all_users()

    render(conn, "admin-dashboard.html", users: users)
    # render(conn, "index.html")
  end

  def question(conn, _param) do
    question_tags = UserManagement.getTags()
    render(conn, "add-question.html", tags: question_tags)
  end

  def add_question(conn, params) do
    question_text = params |> Map.get("question_text")
    IO.inspect(question_text, label: "===>: ")
    UserManagement.post_question(params)
    questions = UserManagement.get_questions()
    render(conn, "dashboard.html", questions: questions)
  end

  def login_user(conn, params) do
    entered_user_name = params |> Map.get("user_name")
    entered_password = params |> Map.get("password")

    user = UserManagement.login_user(entered_user_name, entered_password)

    case user do
      nil ->
        render(conn, "error-page.html")

      %User{is_admin: true} ->
        get_all_users(conn)

      %User{is_admin: false} ->
        questions = UserManagement.get_questions()
        render(conn, "dashboard.html", questions: questions)

      _ ->
        render(conn, "error-page.html")
    end
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

  def delete_user(conn, params) do
    with {:ok, _} <- UserManagement.delete_user(params |> Map.get("uuid")) do
      get_all_users(conn)
    end
  end
end
