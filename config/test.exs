import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_api_assignment, GraphqlApiAssignmentWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TY2c40DC/zXRVv5V62goALCzGfRB0TnsgqAlfNeRlcSMI6sM+yABI5/BOiWTzKEa",
  server: false

config :graphql_api_assignment, GraphqlApiAssignment.Repo,
  database: "graphql_api_assignment_repo_test",
  username: "user",
  password: "password",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  show_sensitive_data_on_connection_error: true,
  log: :debug,
  stacktrace: true,
  pool_size: 10

# In test we don't send emails
config :graphql_api_assignment, GraphqlApiAssignment.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :info

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
