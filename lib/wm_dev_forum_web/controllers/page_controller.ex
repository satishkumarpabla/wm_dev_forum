defmodule WmDevForumWeb.PageController do
  use WmDevForumWeb, :controller
  alias WmDevForum.UserManagement
  alias WmDevForum.Schema.{User, Answer}
  alias WmDevForum.UserManagementQueries

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def back_from_error_page(conn, _params) do
    render(conn, "index.html")
  end

  def get_clicked_movie_details(conn, params) do
    movie_id = params |> Map.get("movie_id")

    movie_url = "https://www.imdb.com/title/" <> movie_id <> "/" <> "?ref_=fn_al_tt_4"

    basic_details = UserManagement.get_basic_movie_details(movie_url)

    # extended_details = UserManagement.get_extended_details(movie_url)
    render(conn, "movie_details.html")
  end

  def get_movie_content(conn, parameters) do
    search_results =
      UserManagement.get_movie_content(parameters |> Map.get("movie_title"), [])
      |> Enum.filter(fn result ->
        result != nil
      end)

    render(conn, "search-results-page.html",
      search_results: search_results,
      search_query: parameters |> Map.get("movie_title")
    )
  end

  def search_genre(conn, parameters) do
    search_results =
      UserManagement.search_for_genre(parameters |> Map.get("genre")) |> Enum.uniq()

    render(conn, "dashboard.html", %{
      available_genres: available_genres(),
      search_results: search_results
    })
  end

  def back_from_login_page(conn, _params) do
    render(conn, "index.html")
  end

  def go_to_dashboard(conn, _params) do
    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(conn.assigns.user.uuid)

    render(conn, "dashboard.html", %{
      my_questions: false,
      questions: questions,
      user_stats: user_stats
    })
  end

  def back_from_search_page(conn, _params) do
    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(conn.assigns.user.uuid)

    render(conn, "dashboard.html", %{
      my_questions: false,
      questions: questions,
      user_stats: user_stats
    })
  end

  def get_user_data_for_profile(conn, params) do
    user_profile_data = UserManagement.get_user_profile_data(params |> Map.get("user_uuid"))
    render(conn, "user_profile.html", user: user_profile_data)
  end

  def back_from_add_question_page(conn, _params) do
    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(conn.assigns.user.uuid)

    render(conn, "dashboard.html", %{
      my_questions: false,
      questions: questions,
      user_stats: user_stats
    })
  end

  def back_from_answers_page(conn, params) do
    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(conn.assigns.user.uuid)

    render(conn, "dashboard.html", %{
      my_questions: false,
      questions: questions,
      user_stats: user_stats
    })
  end

  def register(conn, _params) do
    render(conn, "register.html")
  end

  def search_movies(conn, params) do
    search_text = params |> Map.get("search_tags")

    results_for_title = UserManagementQueries.search_movies_title(search_text)

    results_for_genre = UserManagementQueries.search_on_the_basis_of_genre(search_text)

    results_for_cast = UserManagementQueries.search_on_the_basis_of_cast(search_text)

    updated_result =
      (results_for_title ++ results_for_genre ++ results_for_cast)
      |> Enum.uniq()

    render(conn, "movies-search-results.html", updated_search_results: updated_result)
  end

  def create_user(conn, params) do
    user_map = %{
      user_name: params |> Map.get("user_name"),
      password: params |> Map.get("password"),
      email: params |> Map.get("email"),
      user_uuid: UUID.uuid4()
    }

    UserManagement.create_user(user_map)

    conn
    |> redirect(to: page_path(conn, :index))

    # case UserManagement.create_user(params) do
    #   {:ok, _} ->
    #     conn
    #     |> put_flash(:info, gettext("You have been registered!!!!"))
    #     |> redirect(to: page_path(conn, :register))
    #
    #   {:error, changeset} ->
    #     errors =
    #       changeset.errors
    #       |> Enum.map(fn {key, {msg, _}} ->
    #         {key, msg}
    #       end)
    #
    #     conn
    #     |> put_flash(:error, gettext("Could not register!"))
    #     |> Map.put(:errors, errors)
    #     |> redirect(to: page_path(conn, :register))
    # end
  end

  def dashboard(conn, _params) do
    questions = UserManagement.get_questions()

    user_stats = UserManagement.get_user_stats(conn.assigns.user.uuid)

    conn
    |> render("dashboard.html", %{
      questions: questions,
      user_stats: user_stats,
      my_questions: false
    })
  end

  defp get_all_users(conn) do
    users = UserManagement.get_all_users()

    render(conn, "admin-dashboard.html", users: users)
    # render(conn, "index.html")
  end

  def get_all_questions(conn, _p) do
    loggedin_user =
      conn
      |> get_session(:user)

    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(loggedin_user.uuid)

    render(conn, "dashboard.html",
      questions: questions,
      user_stats: user_stats,
      my_questions: false
    )
  end

  def get_my_questions(conn, _p) do
    loggedin_user =
      conn
      |> get_session(:user)

    questions = UserManagement.get_questions_by_user(loggedin_user.uuid)
    user_stats = UserManagement.get_user_stats(loggedin_user.uuid)

    render(conn, "dashboard.html",
      questions: questions,
      user_stats: user_stats,
      my_questions: true
    )
  end

  def question(conn, _param) do
    question_tags = UserManagement.getTags()
    render(conn, "add-question.html", tags: question_tags)
  end

  def add_question(conn, params) do
    question_text = params |> Map.get("question_text")

    loggedin_user =
      conn
      |> get_session(:user)

    UserManagement.post_question(params, loggedin_user)
    questions = UserManagement.get_questions()
    user_stats = UserManagement.get_user_stats(loggedin_user.uuid)
    # redirect user to dashboard after adding question

    render(conn, "dashboard.html",
      questions: questions,
      user_stats: user_stats,
      my_questions: false
    )
  end

  def login_user(conn, params) do
    entered_user_name = params |> Map.get("user_name")
    entered_password = params |> Map.get("password")

    user = UserManagement.login_user(entered_user_name, entered_password)

    case user do
      nil ->
        render(conn, "error-page.html")

        conn
        |> put_session(:user, user)
        |> redirect(to: page_path(conn, :dashboard))

      _ ->
        render(conn, "dashboard.html", available_genres: available_genres(), search_results: [])
    end
  end

  def get_user_stats(user_uuid) do
    UserManagement.get_user_stats(user_uuid)
  end

  def approve_user(conn, params) do
    user_name = (params |> Map.get("first_name")) <> " " <> (params |> Map.get("last_name"))

    case UserManagement.approve_user(params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("User {%user_name} Successfully Approved."))

      {:error, _} ->
        conn
        |> put_flash(:info, gettext("Unable to approve user."))
    end

    get_all_users(conn)
  end

  def get_answers(conn, params) do
    answers = UserManagement.get_answers_by_question_uuid(Map.get(params, "question_uuid"))

    question = UserManagement.get_question_by_uuid(Map.get(params, "question_uuid"))
    render(conn, "answers.html", answers: answers, question: question)
  end

  def add_answer(conn, params) do
    user_uuid = conn |> get_session(:user) |> Map.get(:uuid)

    UserManagement.add_answer(params["question_uuid"], user_uuid, params["answer"])

    answers = UserManagement.get_answers_by_question_uuid(Map.get(params, "question_uuid"))
    question = UserManagement.get_question_by_uuid(Map.get(params, "question_uuid"))

    conn
    |> redirect(to: page_path(conn, :get_answers, params["question_uuid"]))
  end

  def logout(conn, params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end

  def mark_correct_answer(
        conn,
        %{"answer_uuid" => answer_uuid} = _params
      ) do
    {:ok, %Answer{question_uuid: question_uuid}} = UserManagement.mark_correct_answer(answer_uuid)

    conn
    |> redirect(to: page_path(conn, :get_answers, question_uuid))
  end

  def add_vote(
        conn,
        %{
          "answer_uuid" => answer_uuid,
          "vote_type" => vote_type,
          "question_uuid" => question_uuid
        } = _params
      ) do
    user_uuid = conn.assigns.user.uuid

    UserManagement.add_vote(answer_uuid, user_uuid, vote_type)

    conn
    |> redirect(to: page_path(conn, :get_answers, question_uuid))
  end

  def available_genres() do
    UserManagement.get_distinct_genres()
  end
end
