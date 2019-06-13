defmodule WmDevForum.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "users" do
    field(:uuid, :binary_id)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:is_admin, :boolean, default: false)
    field(:is_accepted, :boolean, default: false)

    timestamps()
  end

  def create_changeset(attr) do
    %User{}
    |> cast([:uuid, :first_name, :last_name, :email, :password, :is_admin, :is_accepted])
    |> validate_required([:first_name, :last_name, :email, :password])
  end

  def update_changeset(%User{} = user, attr) do
    user
    |> cast([:first_name, :last_name, :email, :password, :is_admin, :is_accepted])
    |> validate_required([:first_name, :last_name, :email, :password])
  end
end
