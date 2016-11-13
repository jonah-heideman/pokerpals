# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pokerpals,
  ecto_repos: [Pokerpals.Repo]

# Configures the endpoint
config :pokerpals, Pokerpals.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "p7KoPUH4MHFQcbG6VCHvAjhLQzGliC2hzJFuPTKu1uMnKGFe1ODH/W9/A0FNu85W",
  render_errors: [view: Pokerpals.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pokerpals.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
