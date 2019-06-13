defmodule WmDevForum.UserManagementQueries do
  alias WmDevForum.Schema.{User, Question, Tag}
  alias WmDevForum.Repo
  import Ecto.Query

  def create_user(params) do
    User.create_changeset(params)
    |> Repo.insert()
  end

  def post_question(question) do
    Question.changeset(%{title: question, description: "this is that"})
    |> Repo.insert()
  end

  def check_if_user_is_authentic(user_name, password) do
    Repo.one(
      from(u in User,
        where: u.email == ^user_name and u.password == ^password
      )
    )
  end

  def getTags() do
    Repo.all(from(t in Tag))
  end

  def get_all_users() do
    Repo.all(
      from(u in User,
        where: u.is_admin == false,
        select: %{uuid: u.uuid, first_name: u.first_name, last_name: u.last_name, email: u.email}
      )
    )
  end
end
