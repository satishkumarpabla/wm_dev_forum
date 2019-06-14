defmodule WmDevForum.UserManagementQueries do
  alias WmDevForum.Schema.{User, Question, Tag, QuestionTag, Answer}
  alias WmDevForum.Repo
  import Ecto.Query
  alias Ecto.Multi

  def create_user(params) do
    User.create_changeset(params)
    |> Repo.insert()
  end

  def post_question(question, description, tag_value, loggedin_user_uuid) do
    {:ok, question} =
      Question.create_changeset(%{
        title: question,
        description: description,
        user_uuid: loggedin_user_uuid
      })
      |> Repo.insert()

    QuestionTag.create_changeset(%{question_uuid: question.uuid, tag_uuid: tag_value})
    |> Repo.insert()
  end

  def get_questions() do
    Repo.all(
      from(q in Question,
        inner_join: u in User,
        on: q.user_uuid == u.uuid,
        select: %{
          question_text: q.title,
          description: q.description,
          question_uuid: q.uuid,
          first_name: u.first_name,
          last_name: u.last_name,
          user_uuid: u.uuid
        },
        order_by: [desc: q.inserted_at]
      )
    )
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

  def get_answers_by_question_uuid(question_uuid) do
    from(ans in Answer, where: ans.question_uuid == ^question_uuid, preload: [:user])
    |> Repo.all()
  end

  def get_question_by_uuid(question_uuid) do
    Repo.one(
      from(q in Question,
        inner_join: u in User,
        on: q.user_uuid == u.uuid,
        where: q.uuid == ^question_uuid,
        select: %{
          uuid: q.uuid,
          title: q.title,
          description: q.description,
          first_name: u.first_name,
          last_name: u.last_name
        }
      )
    )
  end

  def add_answer(question_uuid, user_uuid, answer_text) do
    Answer.create_changeset(%{
      question_uuid: question_uuid,
      user_uuid: user_uuid,
      answer_text: answer_text
    })
    |> Repo.insert()
  end
end
