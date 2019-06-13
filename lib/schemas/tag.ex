defmodule WmDevForum.Schema.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias WmDevForum.Schema.Tag

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "tags" do
    field(:title, :string)

    timestamps()
  end

  def create_changeset(attrs) do
    %Tag{}
    |> cast(attrs, [:uuid, :title])
    |> validate_required([:title])
  end

  def update_changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
