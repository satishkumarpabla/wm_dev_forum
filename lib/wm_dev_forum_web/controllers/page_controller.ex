defmodule WmDevForumWeb.PageController do
  use WmDevForumWeb, :controller
  alias WmDevForum.UserManagement

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

      _ ->
        conn
        |> put_flash(:error, gettext("Could not register!"))
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
    render(conn, "dashboard.html")
  end

  def login_user(conn, params) do
    entered_user_name = params |> Map.get("user_name")
    entered_password = params |> Map.get("password")

    user = UserManagement.login_user(entered_user_name, entered_password)

    case user do
      nil ->
        render(conn, "error-page.html")

      user ->
        if user.is_admin do
          get_all_users(conn)
        else
          render(conn, "dashboard.html")
        end
    end
  end
end
