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

jimmy = %{
  uuid: UUID.uuid4(),
  first_name: "Jimmy",
  last_name: "Hobbit",
  email: "jimmy@hotmail.com",
  password: "jimmy",
  is_admin: false,
  is_accepted: false
}

harry = %{
  uuid: UUID.uuid4(),
  first_name: "Harry",
  last_name: "Potter",
  email: "harrypotter29@gmail.com",
  password: "hogwarts",
  is_admin: false,
  is_accepted: false
}

john = %{
  uuid: UUID.uuid4(),
  first_name: "John",
  last_name: "Wick",
  email: "keanureeves@yahoo.com",
  password: "hitman",
  is_admin: true,
  is_accepted: false
}

ethan = %{
  uuid: UUID.uuid4(),
  first_name: "Ethan",
  last_name: "Hunt",
  email: "cool20ethan@gmail.com",
  password: "great",
  is_admin: false,
  is_accepted: false
}

rajesh = %{
  uuid: UUID.uuid4(),
  first_name: "Rajesh",
  last_name: "Roshan",
  email: "rajeshroshan@yahoo.com",
  password: "parody",
  is_admin: false,
  is_accepted: false
}

shubham = %{
  uuid: UUID.uuid4(),
  first_name: "Shubham",
  last_name: "Thakur",
  email: "shubhamthakur@ts.com",
  password: "elmyear",
  is_admin: false,
  is_accepted: false
}

vikrant = %{
  uuid: UUID.uuid4(),
  first_name: "Vikrant",
  last_name: "Rajput",
  email: "vkrajput@gmail.com",
  password: "angular",
  is_admin: false,
  is_accepted: false
}

mandeep = %{
  uuid: UUID.uuid4(),
  first_name: "Mandeep",
  last_name: "Singh",
  email: "masterofscrum@gmail.com",
  password: "agile",
  is_admin: false,
  is_accepted: false
}

users = [jimmy, harry, john, ethan, rajesh, shubham, vikrant, mandeep]

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
  },
  %{
    uuid: UUID.uuid4(),
    title: "Agile",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "C#",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "C",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "C++",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "AWS",
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
]

Repo.insert_all(Tag, tags)

user1 = users |> hd

questions = [
  # %{
  #   uuid: UUID.uuid4(),
  #   title: "Java-Angular",
  #   description: "Java-Angular description",
  #   user_uuid: user1.uuid,
  #   inserted_at: DateTime.utc_now(),
  #   updated_at: DateTime.utc_now()
  # },
  # %{
  #   uuid: UUID.uuid4(),
  #   title: "Elixir-Pheonix",
  #   description: "Elixir-Pheonix description",
  #   user_uuid: user1.uuid,
  #   inserted_at: DateTime.utc_now(),
  #   updated_at: DateTime.utc_now()
  # },
  %{
    uuid: UUID.uuid4(),
    title: "How do we move to router from Elm file?",
    description:
      "I want to move the flow of control to router.ex from my Main.elm file. How am is supposed to do it ?",
    user_uuid: harry.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Creating Query Filters in the Database and Display in html",
    description:
      "I just created a template with lots of filter options. Now I need to make this template do a select directly in the database as the fields are filled. Can you help me ?",
    user_uuid: john.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Problem in paging table without id",
    description:
      "I’m trying to paginate, but I’m getting the following error.A small note: There is no id column in the database.Because this is an external query, I can not give mix ecto.create",
    user_uuid: mandeep.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "path helper removing tags",
    description:
      "I am creating a tagging system where the user will be able to select a tag to list all entries with such tag(s). Its not working.",
    user_uuid: mandeep.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "problem argument error",
    description:
      "Gentlemen, I’m going through a problem. I’m not able to show the “phoenix” on the screen the values he finds. Below I will detail how my files are, with the error. What could it be?",
    user_uuid: rajesh.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Websocket subprotocols with phoenix channels",
    description:
      "Hi everyone! I’m trying to use phoenix websockets as a Transport for SIP. For SIP implementation must use the websocket “sip” subprotocol. (Sec-WebSocket-Protocol: sip header for a handshake)",
    user_uuid: ethan.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "How to use phoenix channels with example",
    description:
      "Hi everyone! I’m trying to use phoenix channels. It would be a great help if you can give me an example.",
    user_uuid: ethan.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Use the same liveview with different routes",
    description:
      "Originally, I had the following routes before Live View.All of this is a bit hacky. Is there a better way to do this with live routes? ",
    user_uuid: ethan.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Annoying js reload",
    description:
      "I use a quite standard Phoenix project and has recently just added a small js sort function for a table. Every now and then it works perfectly well but as soon as I start to make changes the whole thing turns into a lottery (with many loosers) where it at any given change will just stop working and then take ages to get back on line.",
    user_uuid: vikrant.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Calling variables from a method in a different class",
    description:
      "So i am trying to create a report and house it in my MainClass. I can get it to report out from my supporting class(SingleStoryHome) but my prof wants all of our user facing methods in our MainClass.",
    user_uuid: john.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Head First Java - Initial Set Up",
    description:
      "I am just starting on my path and I have followed the original instructions to create the path etc.....  I have then gone to the CMD and typed javac -version and java -version and i get is not recognized as an internal or external command, operable program or batch file. command line.",
    user_uuid: mandeep.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Serialization - readResolve method ? ",
    description: " What is the purpose of readResolve method? ",
    user_uuid: rajesh.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Multidimensional Arrays in Java",
    description:
      "I am not sure how to visualize Multidimensional arrays in Java. Does that mean that you have 5 references that can hold array of 2 strings ?",
    user_uuid: shubham.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  },
  %{
    uuid: UUID.uuid4(),
    title: "Is Array an Object",
    description: "How is array an object?",
    user_uuid: shubham.uuid,
    inserted_at: DateTime.utc_now(),
    updated_at: DateTime.utc_now()
  }
]

Repo.insert_all(Question, questions)

[q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15] = questions
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
