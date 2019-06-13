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
end
