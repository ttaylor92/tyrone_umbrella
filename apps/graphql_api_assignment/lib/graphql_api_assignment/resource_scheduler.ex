defmodule GraphqlApiAssignment.ResourceScheduler do
  @doc false
  use GenServer
  alias SchemasPG.AccountManagement
  alias GraphqlApiAssignment.SecurityClearanceQueue

  @default_name __MODULE__
  @deault_interval :timer.hours(24)

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    {interval, opts} = Keyword.pop(opts, :interval, @deault_interval)
    GenServer.start(__MODULE__, %{interval: interval}, opts)
  end

  # API
  def increment_key(key, name \\ @default_name) do
    GenServer.cast(name, key)
  end

  def get_key_count(key, name \\ @default_name) do
    GenServer.call(name, key)
  end

  @impl true
  def init(state) do
    checkin_all_users()
    schedule_next_run(state.interval)
    {:ok, state}
  end

  @impl true
  def handle_info(:run_daily, state) do
    IO.puts("Starting daily user processing...")
    checkin_all_users()
    schedule_next_run(state.interval)
    {:noreply, state}
  end

  defp checkin_all_users(offset \\ 0) do
    user_ids = AccountManagement.get_user_ids(offset)
    SecurityClearanceQueue.checkin_users(user_ids)
    IO.puts("All users checked in for today.")
  end

  defp schedule_next_run(interval) do
    Process.send_after(__MODULE__, :run_daily, interval)
  end
end
