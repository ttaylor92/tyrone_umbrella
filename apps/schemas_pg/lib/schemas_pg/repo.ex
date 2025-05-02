defmodule SchemasPG.Repo do
  use Ecto.Repo,
    otp_app: :schemas_pg,
    adapter: Ecto.Adapters.Postgres
end
