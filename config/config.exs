# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :wing_manager,
  ecto_repos: [WingManager.Repo]

# Configures the endpoint
config :wing_manager, WingManagerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: WingManagerWeb.ErrorHTML, json: WingManagerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: WingManager.PubSub,
  live_view: [signing_salt: "Nwp6Nmtc"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :wing_manager, WingManager.Mailer, adapter: Swoosh.Adapters.Local

config :ueberauth, Ueberauth,
  providers: [
    discord: {Ueberauth.Strategy.Discord, []}
  ]

config :wing_manager, WingManager.Accounts.Guardian,
  issuer: "wing_manager",
  secret_key: "eMoznuQEgS3oac6FdYMxBcsqKx2M+25+0YJfL9tqdJ9rD3zUXEpl25eui2KHKX+a"

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.15.5",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :petal_components,
       :error_translator_function,
       {WingManagerWeb.CoreComponents, :translate_error}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
