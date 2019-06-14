defmodule WmDevForum.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      timestamps()
    end

    create table(:users, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:first_name, :string, null: false)
      add(:last_name, :string, null: false)
      add(:email, :string, null: false)
      add(:password, :string, null: false)
      add(:role_uuid, references(:roles, column: :uuid, type: :binary_id))
      add(:is_admin, :bool, default: false)
      add(:is_accepted, :bool, default: false)
      timestamps()
    end

    create table(:questions, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:title, :string, null: false)
      add(:description, :text, null: false)
      add(:user_uuid, references(:users, column: :uuid, type: :binary_id, on_delete: :nilify_all))
      timestamps()
    end

    create table(:answers, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:answer_text, :text, null: false)
      add(:is_correct, :bool, default: false)

      add(
        :question_uuid,
        references(:questions, column: :uuid, type: :binary_id, on_delete: :nilify_all)
      )

      add(:user_uuid, references(:users, column: :uuid, type: :binary_id, on_delete: :nilify_all))
      timestamps()
    end

    create table(:tags, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:title, :string, null: false)
      timestamps()
    end

    create table(:questions_tags, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)

      add(
        :question_uuid,
        references(:questions, column: :uuid, type: :binary_id, on_delete: :nilify_all)
      )

      add(:tag_uuid, references(:tags, column: :uuid, type: :binary_id, on_delete: :nilify_all))
      timestamps()
    end

    create(unique_index(:questions_tags, [:question_uuid, :tag_uuid]))

    create table(:votes, primary_key: false) do
      add(:uuid, :binary_id, primary_key: true)
      add(:up, :boolean, default: false)
      add(:down, :boolean, default: false)
      add(:user_uuid, references(:users, column: :uuid, type: :binary_id, on_delete: :nilify_all))

      add(
        :answer_uuid,
        references(:answers, column: :uuid, type: :binary_id, on_delete: :nilify_all)
      )

      timestamps()
    end
  end
end
