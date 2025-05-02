defmodule SchemasPG do
  @moduledoc """
  Documentation for `SchemasPG`.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      @timestamp_type :utc_datetime
      @timestamps_opts type: @timestamp_type

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end
end
