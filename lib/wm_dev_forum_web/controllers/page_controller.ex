defmodule WmDevForumWeb.PageController do
  use WmDevForumWeb, :controller
  alias WmDevForum.UserManagement

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end

  def register_user(conn, params) do
    _user = UserManagement.register_user(params)

    conn =
      conn
      |> put_flash(:info, "You have been registered!!!!")

    render(conn, "register.html")
  end

  def get_all_users(conn, _params) do
  #users = User.get_all_users()

  #render(conn, "users.json", res: %{users: users})
  render conn, "index.html"
  end

end
