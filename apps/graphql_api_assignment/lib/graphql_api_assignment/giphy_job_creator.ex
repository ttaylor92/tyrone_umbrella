defmodule GraphqlApiAssignment.GiphyJobCreator do
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
  def handle_cast({:process_user, user_schema_data}, state) do
    task = Task.Supervisor.async_nolink(GraphqlApiAssignment.TaskSupervisor, fn ->
      TaskService.UserPostSetup.handle_user_creation(user_schema_data)
    end)

    {:noreply, %{state | ref: task.ref}}
  end

  @impl true
  def handle_info({ref, _result}, state) do
    Process.demonitor(ref, [:flush])
    Logger.info("User was processed.")
    {:noreply, %{state | ref: nil}}
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    Logger.info("The process has failed unexpectedly: #{inspect(ref)}")
    {:noreply, %{state | ref: nil}}
  end

  # API
  def process_user(user, name \\ @default_name) do
    GenServer.cast(name, {:process_user, user})
  end
end
