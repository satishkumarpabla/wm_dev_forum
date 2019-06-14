defmodule WmDevForum.UserManagement do
  alias WmDevForum.UserManagementQueries

  def create_user(params) do
    UserManagementQueries.create_user(params)
  end

  def login_user(user_name, password) do
    UserManagementQueries.check_if_user_is_authentic(user_name, password)
  end

  def get_all_users() do
    UserManagementQueries.get_all_users()
  end

  def getTags() do
    UserManagementQueries.getTags()
  end

  def post_question(params) do
    # question_data = %{}
    UserManagementQueries.post_question(params |> Map.get("question_text"))
  end

  def approve_user(params) do
    UserManagementQueries.approve_user(params |> Map.get("uuid"))
  end

  def delete_user(user_uuid) do
    user_to_be_deleted = UserManagementQueries.get_user_from_user_uuid(user_uuid)

    case user_to_be_deleted do
      nil ->
        {:error, :no_user_records_found}

      %{} ->
        UserManagementQueries.delete_user(user_uuid)
    end
  end
end
