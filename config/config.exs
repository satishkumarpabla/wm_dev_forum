# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wm_dev_forum,
  ecto_repos: [WmDevForum.Repo]

# Configures the endpoint
config :wm_dev_forum, WmDevForumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+RS/lpucZvpQ3+x4QPxRidVoqYjp3OhM2olfINvp8h42R2HOyECdCfdjZfJNXfmn",
  render_errors: [view: WmDevForumWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WmDevForum.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, []}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  # made up code
  client_id: "869731958402-5l6bd6dj45mlihv477ha3oi3o2o84v2s.apps.googleusercontent.com",
  # made up code
  client_secret: "SNDJbxxQGFi2wqDp2GVFPgpL"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
