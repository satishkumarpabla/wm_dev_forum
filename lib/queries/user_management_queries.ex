defmodule WmDevForum.UserManagementQueries do
  alias WmDevForum.Schema.{User, Question, Tag}
  alias WmDevForum.Repo
  import Ecto.Query
  alias Ecto.Multi

  def create_user(params) do
    User.create_changeset(params)
    |> Repo.insert()
  end

  def post_question(question, description) do
    Question.create_changeset(%{
      title: question,
      description: description,
      user_uuid: "763d9d88-ac8c-4213-8819-7b853d66c980"
    })
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

  def approve_user(user_uuid) do
    user_data_from_database = User |> Repo.get_by(uuid: user_uuid)

    User.update_changeset(user_data_from_database, %{is_accepted: true})
    |> Repo.update()
  end

  def delete_user(user_uuid) do
    Repo.get!(User, user_uuid) |> Repo.delete()
  end

  def get_user_from_user_uuid(user_uuid) do
    Repo.one(
      from(user in User,
        where: user.uuid == ^user_uuid
      )
    )
  end
end
