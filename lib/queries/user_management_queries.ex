defmodule WmDevForum.UserManagementQueries do
  alias WmDevForum.Schema.User
  alias WmDevForum.Repo
  import Ecto.Query

  def create_user(params) do
    User.create_changeset(params)
    |> Repo.insert()
  end

  def check_if_user_is_authentic(user_name, password) do
    Repo.one(
      from(u in User,
        where: u.email == ^user_name and u.password == ^password,
        select: u.uuid
      )
    )
  end
end
