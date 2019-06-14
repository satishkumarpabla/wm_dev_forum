defmodule WmDevForumWeb.VerifyUser do
  import Plug.Conn
  alias WmDevForumWeb.Router.Helpers
  alias WmDevForum.Schema.User
  alias WmDevForum.UserManagementQueries

  def verify_user(conn, _default) do
    user = conn |> get_session(:user)

    with %{} = user <- conn |> get_session(:user),
         %User{} <- UserManagementQueries.get_user_from_user_uuid(user.uuid) do
      conn
      |> assign(:user, user)
    else
      _ ->
        conn
        |> configure_session(drop: true)
        |> Phoenix.Controller.redirect(to: Helpers.page_path(conn, :index))
        |> halt
    end
  end
end
