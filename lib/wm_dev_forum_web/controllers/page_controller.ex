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
    _user = UserManagement.create_user(params)

    conn =
      conn
      |> put_flash(:info, "You have been registered!!!!")

    render(conn, "register.html")
  end

  defp get_all_users(conn) do
    users = UserManagement.get_all_users()

    render(conn, "admin-dashboard.html", users: users)
    # render(conn, "index.html")
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
