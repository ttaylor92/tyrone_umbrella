defmodule TaskService.NodeStatus do
  use Oban.Worker,
    unique: [
      period: 60,
      fields: [:meta, :worker],
      states: [:scheduled]
    ]

  @impl Oban.Worker
  def perform(_) do
    Enum.each(Node.list(), fn node ->
      IO.inspect("Node: #{node}, is available")
    end)

    :ok
  end
end
