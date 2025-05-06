defmodule SharedUtils.SchemaUtils do
  def to_map(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> Map.drop([:__meta__, :__struct__])
  end
end
