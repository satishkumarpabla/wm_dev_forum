defmodule WmDevForum.Schema.Movies do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias WmDevForum.Schema.Movies
  alias Comeonin.Bcrypt

  @primary_key {:movie_uuid, :binary_id, autogenerate: true}

  schema "movies" do
    field(:cast, {:array, :string})
    field(:genres, {:array, :string})
    field(:title, :string)
    field(:year, :integer)
  end

  def create_changeset(attrs) do
    %Movies{}
    |> cast(attrs, [:movie_uuid, :cast, :genres, :title, :year])
    |> validate_required([:year, :title])
  end
end
