defmodule WmDevForum.Schema.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias WmDevForum.Schema.{User, Question, Answer}
  alias Comeonin.Bcrypt

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "answers" do
    field(:answer_text, :string)
    field(:user_uuid, :binary_id)
    field(:question_uuid, :binary_id)
    field(:is_correct, :boolean, default: false)

    belongs_to(:user, User,
      foreign_key: :user_uuid,
      references: :uuid,
      define_field: false
    )

    belongs_to(:question, Question,
      foreign_key: :question_uuid,
      references: :uuid,
      define_field: false
    )

    timestamps()
  end

  def create_changeset(attrs) do
    %Answer{}
    |> cast(attrs, [:answer_text, :user_uuid, :question_uuid, :is_correct])
    |> validate_required([:answer_text, :user_uuid, :question_uuid])

    # |> encrypt_password()
  end

  def update_changeset(%Answer{} = answer, attrs) do
    answer
    |> cast(attrs, [:answer_text, :is_correct])
  end
end
