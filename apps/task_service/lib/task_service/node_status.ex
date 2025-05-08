defmodule TaskService.NodeStatus do
  require Logger

  use Oban.Worker,
    unique: [
      period: 60,
      fields: [:meta, :worker],
      states: [:scheduled]
    ]

  @impl Oban.Worker
  def perform(_) do
    Enum.each(Node.list(), fn node ->
      Logger.info("Node: #{node}, is available")
    end)

    :ok
  end
end
