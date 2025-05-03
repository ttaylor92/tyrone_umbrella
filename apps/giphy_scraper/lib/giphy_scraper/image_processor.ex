defmodule GiphyScraper.ImageProcessor do
  use GenServer
  require Logger

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenServer.start(__MODULE__, %{ref: nil}, opts)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:process_chunk, chunk}, state) do
    task = Task.Supervisor.async_nolink(GiphyScraper.TaskSupervisor, fn ->
      Enum.each(chunk, fn giphy_image ->
        SchemasPG.Giphy.create_image(giphy_image)
      end)
    end)

    {:noreply, %{state | ref: task.ref}}
  end

  @impl true
  def handle_info({ref, result}, state) do
    Process.demonitor(ref, [:flush])
    Logger.info("#{length(result)}, was processed.")
    {:noreply, %{state | ref: nil}}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    Logger.info("The process has failed unexpectedly: #{inspect(ref)}")
    {:noreply, %{state | ref: nil}}
  end

  # API
  def process_chunk(chunk, name \\ @default_name) do
    GenServer.cast(name, {:process_chunk, chunk})
  end
end
