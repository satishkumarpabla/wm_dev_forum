defmodule WmDevForum.UserManagement do
  alias WmDevForum.UserManagementQueries

  def create_user(params) do
    UserManagementQueries.create_user(params)
  end

  def login_user(user_name, password) do
    UserManagementQueries.check_if_user_is_authentic(user_name, password)
  end

  def get_user_stats(user_uuid) do
    user_answers = UserManagementQueries.get_users_total_answers_by_user_uuid(user_uuid)

    number_of_correct_answers =
      user_answers
      |> Enum.filter(fn answer -> answer.is_correct end)
      |> Enum.count()

    total_answers =
      user_answers
      |> Enum.count()

    # up_votes and down votes data to be fetched later once the respective functionalities are implemented

    total_questions_posted = UserManagementQueries.get_total_questions_posted_by_user(user_uuid)

    %{
      number_of_correct_answers: number_of_correct_answers,
      total_answers: total_answers,
      total_questions_posted: total_questions_posted
    }
  end

  def get_all_users() do
    UserManagementQueries.get_all_users()
  end

  def getTags() do
    UserManagementQueries.getTags()
  end

  def post_question(params, loggedin_user) do
    # question_data = %{}
    UserManagementQueries.post_question(
      params |> Map.get("question_text"),
      params |> Map.get("description"),
      params |> Map.get("tag_value"),
      loggedin_user.uuid
    )
  end

  def get_questions() do
    UserManagementQueries.get_questions()
  end

  def approve_user(params) do
    UserManagementQueries.approve_user(params |> Map.get("uuid"))
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
