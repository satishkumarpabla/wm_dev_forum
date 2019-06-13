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

  def login_user(conn, params) do
    entered_user_name = params |> Map.get("user_name")
    entered_password = params |> Map.get("password")

    IO.inspect([entered_user_name, entered_password], label: "22222222222222222")
    render(conn, "dashboard.html")
  end
end
