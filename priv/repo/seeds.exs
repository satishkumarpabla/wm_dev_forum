# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WmDevForum.Repo.insert!(%WmDevForum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias WmDevForum.UserManagement
alias WmDevForum.Schema.{User, Tag, Question, QuestionTag}
alias WmDevForum.Repo
# deleting all data before running seeds file
IO.puts("Deleting data!!")
Repo.delete_all(User)
Repo.delete_all(Tag)
Repo.delete_all(Question)
Repo.delete_all(QuestionTag)

# Start seeding data
IO.puts("Seeding data!!")

users = [
  %{
    uuid: UUID.uuid4(),
    first_name: "Jimmy",
    last_name: "Hobbit",
    email: "jimmy@hotmail.com",
    password: "jimmy",
    is_admin: false,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "Harry",
    last_name: "Potter",
    email: "harrypotter29@gmail.com",
    password: "hogwarts",
    is_admin: false,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "John",
    last_name: "Wick",
    email: "keanureeves@yahoo.com",
    password: "hitman",
    is_admin: true,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "Ethan",
    last_name: "Hunt",
    email: "cool20ethan@gmail.com",
    password: "great",
    is_admin: false,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "Rajesh",
    last_name: "Roshan",
    email: "rajeshroshan@yahoo.com",
    password: "parody",
    is_admin: false,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "Shubham",
    last_name: "Thakur",
    email: "shubhamthakur@ts.com",
    password: "elmyear",
    is_admin: false,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "Vikrant",
    last_name: "Rajput",
    email: "vkrajput@gmail.com",
    password: "angular",
    is_admin: false,
    is_accepted: false
  },
  %{
    uuid: UUID.uuid4(),
    first_name: "Mandeep",
    last_name: "Singh",
    email: "masterofscrum@gmail.com",
    password: "agile",
    is_admin: false,
    is_accepted: false
  }
]

users
|> Enum.map(fn user_map ->
  user_map |> UserManagement.create_user()
end)

tags = [
  %{
    uuid: UUID.uuid4(),
    title: "Angular",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Java",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Phoenix",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Elm",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Elixir",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
]

Repo.insert_all(Tag, tags)

user1 = users |> hd

questions = [
  %{
    uuid: UUID.uuid4(),
    title: "Java-Angular",
    description: "Java-Angular description",
    user_uuid: user1.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Elixir-Pheonix",
    description: "Elixir-Pheonix description",
    user_uuid: user1.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
]

Repo.insert_all(Question, questions)

[q1, q2] = questions
[tag1, tag2, tag3 | _] = tags

questions_tags = [
  %{
    uuid: UUID.uuid4(),
    question_uuid: q1.uuid,
    tag_uuid: tag1.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    question_uuid: q1.uuid,
    tag_uuid: tag2.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    question_uuid: q2.uuid,
    tag_uuid: tag2.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    question_uuid: q2.uuid,
    tag_uuid: tag3.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
]

Repo.insert_all(QuestionTag, questions_tags)
