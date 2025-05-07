defmodule SchemasPG.Support.Datacase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Oban.Testing, repo: SchemasPG.Repo
    end
  end

  setup tags do
    setup_sandbox(tags)
    :ok
  end

  def setup_sandbox(tags) do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(SchemasPG.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(SchemasPG.Repo, {:shared, self()})
    end
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        atom_key = String.to_existing_atom(key)
        opts |> Keyword.get(atom_key, key) |> to_string()
      end)
    end)
  end
end
