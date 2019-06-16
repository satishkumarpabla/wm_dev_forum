defmodule WmDevForum.UserManagement do
  alias WmDevForum.UserManagementQueries

  def create_user(params) do
    UserManagementQueries.create_user(params)
  end

  defp filter_tags_on_the_basis_of_tags(tag, tags_data_from_query) do
    tags_data_from_query
    |> Enum.map(fn query_tag ->
      if query_tag.tag_title == tag do
        query_tag
      else
        query_tag.title
      end
    end)
  end

  defp get_filtered_results_on_title_description(questions, tag) do
    questions
    |> Enum.map(fn question ->
      if question.title =~ tag || question.description =~ tag do
        question
      end
    end)
  end

  # def get_search_results(search_tags, user_uuid) do
  #   questions = UserManagementQueries.get_search_results()
  #
  #   title_description_filter =
  #     search_tags
  #     |> String.split()
  #     |> Enum.map(fn tag ->
  #       get_filtered_results_on_title_description(questions, tag)
  #     end)
  #     |> Enum.concat()
  #     |> Enum.filter(fn question -> question != nil end)
  #     |> IO.inspect(label: "111111111111111111111111111")
  #
  #   tags_data_from_query =
  #     UserManagementQueries.get_question_tags()
  #     |> Enum.uniq()
  #     |> IO.inspect(label: "333333333333333333333")
  #
  #   filter_for_tags =
  #     search_tags
  #     |> String.split()
  #     |> Enum.map(fn tag ->
  #       filter_tags_on_the_basis_of_tags(tag, tags_data_from_query)
  #     end)
  #     |> Enum.concat()
  #     |> Enum.filter(fn question -> question != nil end)
  # end


  def get_search_results(search_tags, _user_uuid) do
      search_tags
      |> String.split()
      |> Enum.map(fn tag ->
        UserManagementQueries.get_question_uuids_by_search_tag(tag)
      end)
      |> List.flatten()
      |> Enum.uniq()
      |> UserManagementQueries.get_questions_by_uuids()
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
      total_questions_posted: total_questions_posted,
      user_uuid: user_uuid
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

  def get_questions_by_user(user_uuid) do
    UserManagementQueries.get_questions_by_user(user_uuid)
  end

  def approve_user(params) do
    UserManagementQueries.approve_user(params |> Map.get("uuid"))
  end

  def get_answers_by_question_uuid(question_uuid) do
    UserManagementQueries.get_answers_by_question_uuid(question_uuid)
    |> Enum.map(fn answer ->
      {up_votes, down_votes} =
        Enum.reduce(answer.votes, {0, 0}, fn vote, {up, down} ->
          if vote.up do
            {up + 1, down}
          else
            {up, down + 1}
          end
        end)

      Map.merge(answer, %{up_votes: up_votes, down_votes: down_votes})
    end)
  end

  def get_question_by_uuid(question_uuid) do
    UserManagementQueries.get_question_by_uuid(question_uuid)
  end

  def add_answer(question_uuid, user_uuid, answer_text) do
    UserManagementQueries.add_answer(question_uuid, user_uuid, answer_text)
  end

  def mark_correct_answer(answer_uuid) do
    UserManagementQueries.update_answer(answer_uuid, %{is_correct: true})
  end

  def add_vote(answer_uuid, user_uuid, "up" = _vote_type) do
    UserManagementQueries.add_vote(%{answer_uuid: answer_uuid, user_uuid: user_uuid, up: true})
  end

  def add_vote(answer_uuid, user_uuid, "down" = _vote_type) do
    UserManagementQueries.add_vote(%{answer_uuid: answer_uuid, user_uuid: user_uuid, down: true})
  end
end
