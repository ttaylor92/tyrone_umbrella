# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

apps = [
  :schemas_pg,
  :graphql_api_assignment,
  :giphy_scraper,
  :task_service
]

for app <- apps do
  config app, :mix_env, Mix.env()
end

config :schemas_pg, SchemasPG.Repo,
  database: "graphql_api_assignment_repo",
  username: "user",
  password: "password",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  log: :debug,
  stacktrace: true

config :schemas_pg,
  ecto_repos: [SchemasPG.Repo]

config :ecto_shorts,
  repo: SchemasPG.Repo,
  error_module: EctoShorts.Actions.Error

config :graphql_api_assignment,
  generators: [timestamp_type: :utc_datetime]

config :prometheus_telemetry,
  default_millisecond_buckets: [100, 300, 500, 1000, 2000, 5000, 10_000],
  default_microsecond_buckets: [50_000, 100_000, 250_000, 500_000, 750_000],
  measurement_poll_period: :timer.seconds(10),
  ecto_max_query_length: 150,
  ecto_known_query_module: nil

config :request_cache_plug,
  enabled?: true,
  verbose?: false,
  graphql_paths: ["/graphiql", "/graphql"],
  request_cache_module: GraphqlApiAssignment.RedixPool

config :libring,
  rings: [
    ring_a: [monitor_nodes: true],
    ring_b: [monitor_nodes: true]
  ]

# Configures the endpoint
config :graphql_api_assignment, GraphqlApiAssignmentWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: GraphqlApiAssignmentWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: GraphqlApiAssignment.PubSub,
  live_view: [signing_salt: "wPPyFLmR"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :graphql_api_assignment, GraphqlApiAssignment.Mailer, adapter: Swoosh.Adapters.Local

if Mix.env() === :test do
  config :task_service, Oban,
    testing: :inline,
    repo: SchemasPG.Repo
else
  config :task_service, Oban,
    notifier: Oban.Notifiers.Postgres,
    engine: Oban.Engines.Basic,
    repo: SchemasPG.Repo,
    plugins: [
      Oban.Plugins.Lifeline,
      Oban.Plugins.Reindexer,
      {Oban.Plugins.Pruner, max_age: :timer.hours(24)}
    ],
    queues: [default: 10]
end


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

if File.exists?(Path.expand("config.secret.exs", __DIR__)) do
  import_config "config.secret.exs"
end

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
