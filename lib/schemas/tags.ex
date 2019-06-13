defmodule WmDevForum.Schema.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias WmDevForum.Schema.Tag
  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "tags" do
    field(:title, :string)

    timestamps()
  end

  def changeset(attrs) do
    %Tag{}
    |> cast(attrs, [:uuid, :title])
  end
end
