defmodule GraphqlApiAssignment.Support.TestDatabaseHelper do
  def wait_for_database(repo, retries \\ 5) do
    case Ecto.Adapters.SQL.query(repo, "SELECT 1", []) do
      {:ok, _result} ->
        :ok

      {:error, _} when retries > 0 ->
        # Create and migrate the test database
        Mix.Task.run("ecto.create", ["--quiet"])
        Mix.Task.run("ecto.migrate", ["--quiet"])

        # Wait 1 second before retrying
        :timer.sleep(1000)
        wait_for_database(repo, retries - 1)

      {:error, reason} ->
        Mix.raise("Failed to connect to database after retries: #{inspect(reason)}")
    end
  end
end
