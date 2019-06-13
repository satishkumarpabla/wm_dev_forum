defmodule WmDevForum.Schema.Question do
  use Ecto.Schema
  import Ecto.Changeset

  alias WmDevForum.Schema.{Question, User, Tag}

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "questions" do
    field(:title, :string)
    field(:description, :string)
    field(:user_uuid, :binary_id)

    belongs_to(:user, User,
      foreign_key: :user_uuid,
      references: :uuid,
      define_field: false
    )

    many_to_many(:tags, Tag,
      join_through: "questions_tags",
      join_keys: [question_uuid: :uuid, tags_uuid: :uuid],
      unique: true
    )

    timestamps()
  end

  def create_changeset(attrs) do
    %Question{}
    |> cast(attrs, [:uuid, :title, :description, :user_uuid])
    |> validate_required([:title, :description, :user_uuid])
  end

  def update_changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:uuid, :title, :description])
    |> validate_required([:title, :description])
  end
end
