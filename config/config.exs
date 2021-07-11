# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :my_app,
  ecto_repos: [MyApp.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :my_app, MyAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dCHzrDrFf/G9OJDp++AhAuuk/pMgzSFVvHBLoR66rHJ3vmrsBE5gzN5ImIXYX8i/",
  render_errors: [view: MyAppWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: MyApp.PubSub,
  live_view: [signing_salt: "z/QQCySR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# in each environment config file you should overwrite this if it's external
config :my_app, MyApp.Identity.Guardian,
  issuer: "my_app",
  secret_key: "Secure random key, run `mix guardian.gen.secret` to generate one"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
