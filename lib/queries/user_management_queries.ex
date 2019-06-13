defmodule WmDevForum.UserManagementQueries do
  alias WmDevForum.Schema.User
  alias WmDevForum.Repo

  def create_user(params) do
    User.create_changeset(params)
    |> Repo.insert()
  end
end
