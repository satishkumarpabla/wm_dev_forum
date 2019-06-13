defmodule WmDevForum.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias WmDevForum.Schema.User
  alias Comeonin.Bcrypt

  @primary_key {:uuid, :binary_id, autogenerate: true}

  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:password, :string)
    field(:is_admin, :boolean, default: false)
    field(:is_accepted, :boolean, default: false)

    timestamps()
  end

  def create_changeset(attrs) do
    %User{}
    |> cast(attrs, [:uuid, :first_name, :last_name, :email, :password, :is_admin, :is_accepted])
    |> validate_required([:first_name, :last_name, :email, :password])
    |> encrypt_password()
  end

  def update_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :is_admin, :is_accepted])
    |> validate_required([:first_name, :last_name, :email, :password])
  end

  defp encrypt_password(changeset) do
    case changeset do
      %Changeset{valid?: true, changes: changes} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(changes.password))

      _ ->
        changeset
    end
  end
end
