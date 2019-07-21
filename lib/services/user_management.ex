defmodule WmDevForum.UserManagement do
  alias WmDevForum.UserManagementQueries

  def create_user(user_map) do
    UserManagementQueries.create_user(user_map)
  end

  def search_for_genre(genre) do
    UserManagementQueries.search_for_genre(genre)
  end

  def get_movie_content(movie_title, list_of_urls) do
    movie_title_with_spaces_removed =
      movie_title
      |> String.split()
      |> Enum.reduce("", fn word, acc ->
        acc <> word
      end)

    source_url = "https://www.imdb.com/find?ref_=nv_sr_fn&q="
    updated_url = source_url <> movie_title_with_spaces_removed <> "&s=all"

    case HTTPoison.get(updated_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        movie_names =
          body
          |> Floki.find(".result_text")
          |> Enum.map(fn response ->
            extracted_url =
              response
              |> elem(2)
              |> Enum.at(0)
              |> elem(1)
              |> Enum.at(0)
              |> elem(1)
              |> filter_on_the_basis_of_title()

            if extracted_url != "" do
              updated_url = "http:www.imdb.com" <> extracted_url

              list_of_urls
              |> Enum.concat([updated_url])

              extracted_name =
                response
                |> Floki.text()
                |> String.split("\n")
                |> Enum.at(0)

              extracted_movie_id =
                extracted_url
                |> String.split("/")
                |> Enum.at(2)

              %{
                movie_name: extracted_name,
                movie_url: updated_url,
                movie_id: extracted_movie_id
              }
            end
          end)

        movie_names

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.inspect(label: " REQUEST FAILED")
    end
  end

  defp filter_on_the_basis_of_title(extracted_url) do
    if extracted_url |> String.contains?("title/") do
      extracted_url
    else
      ""
    end
  end

  def get_basic_movie_details(movie_url) do
    movie_cast = []

    case HTTPoison.get(movie_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        floki_response =
          body
          |> Floki.find(".credit_summary_item")

        director_name = extract_directors_name(floki_response)

        writer_name = extract_writers_name(floki_response)

        cast =
          floki_response
          |> Enum.at(2)
          |> elem(2)
          |> Enum.map(fn resp ->
            # THE FOLLOWING CONDITION IF CONDITION IS USED SO AS TO NOT ALLOW " ", " " OR STRINGS TO BE PRECISE TYPES OF VALUES TO GO INTO THE BELOW LOGIC IT MIGHT BE NEEDEED TO CHANGE
            if !(resp |> String.valid?()) do
              resp
              |> elem(2)
              |> Enum.map(fn data ->
                movie_cast |> Enum.concat([data])
              end)
            else
              [[""]]
            end
          end)
          |> Enum.concat()
          |> Enum.concat()
          |> List.delete("Stars:")
          |> List.delete("See full cast & crew")
          |> List.delete("|")
          |> Enum.filter(fn name -> name != "" end)

        %{
          director_name: director_name,
          writer_name: writer_name,
          cast: cast
        }

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.inspect(label: "UNABLE TO GET RESULT")
    end
  end

  def get_extended_details(movie_url) do
    case HTTPoison.get(movie_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        floki_response =
          body
          |> Floki.find(".txt-block")
          |> IO.inspect(label: "FETCHED RESPONSE ")

        parents_guide =
          floki_response
          |> Enum.at(0)
          |> elem(2)
          |> Enum.at(1)
          |> elem(2)
          |> Enum.at(0)
          |> elem(2)
          |> Enum.at(0)
          |> IO.inspect(label: "PARENTS GUIDE")

        language =
          floki_response
          |> Enum.at(1)
          |> elem(2)
          |> Enum.at(1)
          |> elem(2)
          |> Enum.at(0)
          |> IO.inspect(label: "LANGUAGE")

        release_date =
          floki_response
          |> Enum.at(3)
          |> elem(2)
          |> Enum.at(1)
          |> String.trim()
          |> IO.inspect(label: "RELEASE DATE")

      # |> elem(2)
      # |> Enum.at(1)
      # |> elem(2)
      # |> Enum.at(0)

      # |> Enum.at()

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("UNABLE TO FETCH A SUCCESSFULL RESPONSE ")
    end
  end

  defp extract_directors_name(floki_response) do
    floki_response
    |> Enum.at(0)
    |> get_name_from_html_structure()
  end

  defp extract_writers_name(floki_response) do
    floki_response
    |> Enum.at(1)
    |> get_name_from_html_structure()
  end

  def get_name_from_html_structure(response_tree_node) do
    response_tree_node
    |> elem(2)
    |> Enum.at(1)
    |> elem(2)
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

  def get_user_profile_data(user_uuid) do
    UserManagementQueries.get_user_profile_data(user_uuid)
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

  #
  #   tags_data_from_query =
  #     UserManagementQueries.get_question_tags()
  #     |> Enum.uniq()
  #
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

    total_questions_posted =
      UserManagementQueries.get_total_questions_posted_by_user(user_uuid)
      |> Enum.count()

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

  def get_distinct_genres() do
    UserManagementQueries.get_distinct_movies()
    |> Enum.concat()
    |> Enum.uniq()
  end
end
