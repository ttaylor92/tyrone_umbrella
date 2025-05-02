defmodule SchemasPG.Config do
  @moduledoc false
  @app :schemas_pg

  def repo, do: Application.get_env(@app, SchemasPG.Repo)

  def mix_env, do: Application.fetch_env!(@app, :mix_env)
end
