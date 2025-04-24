defmodule GraphqlApiAssignment.TokenCache do
  use GenServer

  @default_name __MODULE__
  @table_name :user_tokens

  def start_link(opts \\ []) do
    table_name = Keyword.get(opts, :table_name, @table_name)
    opts = Keyword.put_new(opts, :name, @default_name)
    GenServer.start(__MODULE__, %{table_name: table_name}, opts)
  end

  @impl true
  def init(%{table_name: table_name}) do
    case :ets.whereis(table_name) do
      :undefined ->
        :ets.new(table_name, [:named_table, read_concurrency: true])
      _table_ref ->
        :ok
    end
    {:ok, %{table_name: table_name}}
  end

  @impl true
  def handle_call({:get, user_id}, _from, state) do
    case :ets.lookup(state.table_name, user_id) do
      [{^user_id, token}] -> {:reply, token, state}
      [] -> {:reply, "Token creation is processing. Token will be distributed once processing is done.", state}
    end
  end

  @impl true
  def handle_cast({:put, user_id, token}, state) do
    :ets.insert(state.table_name, {user_id, token})
    {:noreply, state}
  end

  @impl true
  def handle_cast({:delete, user_id}, state) do
    :ets.delete(state.table_name, user_id)
    {:noreply, state}
  end

  # API
  def get(user_id, name \\ @default_name) do
    GenServer.call(name, {:get, user_id})
  end

  def put(user_id, token, name \\ @default_name) do
    GenServer.cast(name, {:put, user_id, token})
  end

  def delete(user_id, name \\ @default_name) do
    GenServer.cast(name, {:delete, user_id})
  end
end
