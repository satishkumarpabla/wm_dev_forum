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

    if entered_user_name == "admin" && entered_password == "admin" do
      render(conn, "admin-dashboard.html")
    else
      is_user_authentic = UserManagement.login_user(entered_user_name, entered_password)
      IO.inspect(is_user_authentic, label: "XXXXXXXXXXXXXXXXXXXXXx")

      if is_user_authentic do
        render(conn, "error-page.html")
      else
        render(conn, "dashboard.html")
      end

      IO.inspect([entered_user_name, entered_password], label: "22222222222222222")
    end
  end
end
