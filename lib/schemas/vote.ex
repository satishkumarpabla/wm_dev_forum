defmodule WmDevForum.Schema.Vote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias WmDevForum.Schema.{Vote, User, Answer}
  alias Comeonin.Bcrypt

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "votes" do
    field(:up, :boolean, default: false)
    field(:down, :boolean, default: false)
    field(:user_uuid, :binary_id)
    field(:answer_uuid, :binary_id)

    belongs_to(:user, User,
      foreign_key: :user_uuid,
      references: :uuid,
      define_field: false
    )

    belongs_to(:answer, Answer,
      foreign_key: :answer_uuid,
      references: :uuid,
      define_field: false
    )

    timestamps()
  end

  def create_changeset(attrs) do
    %Vote{}
    |> cast(attrs, [:up, :down, :user_uuid, :answer_uuid])
    |> validate_required([:user_uuid, :answer_uuid])
  end
end
