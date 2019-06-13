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
alias WmDevForum.Schema.User

[
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
|> Enum.map(fn user_map ->
  user_map |> UserManagement.create_user()
end)
