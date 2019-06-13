defmodule WmDevForumWeb.PageController do
  use WmDevForumWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def get_all_users(conn, _params) do
  #users = User.get_all_users()

  #render(conn, "users.json", res: %{users: users})
  render conn, "index.html"
  end

end
