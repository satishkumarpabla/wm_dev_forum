defmodule WmDevForum.Schema.QuestionTag do
  use Ecto.Schema
  import Ecto.Changeset

  alias WmDevForum.Schema.{Question, Tag, QuestionTag}

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "questions_tags" do
    field(:question_uuid, :binary_id)
    field(:tag_uuid, :binary_id)

    belongs_to(:question, Question,
      foreign_key: :question_uuid,
      references: :uuid,
      define_field: false
    )

    belongs_to(:tag, Tag,
      foreign_key: :tag_uuid,
      references: :uuid,
      define_field: false
    )

    timestamps()
  end

  def create_changeset(attrs) do
    %QuestionTag{}
    |> cast(attrs, [:uuid, :question_uuid, :tag_uuid])
    |> validate_required([:question_uuid, :tag_uuid])
  end
end
