defmodule WmDevForum.Schema.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias WmDevForum.Schema.Question
  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "questions" do
    field(:title, :string)
    field(:description, :string)

    timestamps()
  end

  def changeset(attrs) do
    %Question{}
    |> cast(attrs, [:uuid, :title, :description])
  end
end
