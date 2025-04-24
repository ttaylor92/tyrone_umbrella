defmodule GraphqlApiAssignment.Repo do
  use Ecto.Repo,
    otp_app: :graphql_api_assignment,
    adapter: Ecto.Adapters.Postgres
end
