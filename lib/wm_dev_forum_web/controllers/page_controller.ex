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
end
