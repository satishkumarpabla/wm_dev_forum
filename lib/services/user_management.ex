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
    UserManagementQueries.post_question(
      params |> Map.get("question_text"),
      params |> Map.get("description")
    )
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

  def get_answers_by_question_uuid(question_uuid) do
    UserManagementQueries.get_answers_by_question_uuid(question_uuid)
  end

  def get_question_by_uuid(question_uuid) do
    UserManagementQueries.get_question_by_uuid(question_uuid)
  end

  def add_answer(question_uuid, user_uuid, answer_text) do
    UserManagementQueries.add_answer(question_uuid, user_uuid, answer_text)
  end
end
