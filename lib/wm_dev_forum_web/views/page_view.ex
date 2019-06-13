defmodule WmDevForumWeb.PageView do
  use WmDevForumWeb, :view

  def render("user.json", %{user: user}) do
    %{
      uuid: user.uuid,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email
    }
  end

  def render("users.json", %{users: users}) do
    render_many(users, WmDevForumWeb.PageView, "user.json")
  end
end
