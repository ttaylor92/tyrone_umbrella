defmodule GraphqlApiAssignment.SecurityClearanceQueue do
  use GenServer

  alias GraphqlApiAssignment.SecurityClearanceQueue.State

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenServer.start(__MODULE__, %{}, opts)
  end

  @impl true
  def init(_) do
    {:ok, State.new()}
  end

  @impl true
  def handle_cast({:checkin_user, user_id}, state) do
    {:ok, state} = State.checkin_user(state, user_id)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:checkin_users, user_ids}, state) do
    {:ok, state} = State.checkin_users(state, user_ids)
    {:noreply, state}
  end

  @impl true
  def handle_call({:checkout_users, count}, _from, state) do
    result =
      Enum.reduce_while(1..count, {[], state}, fn _, {user_ids, state} ->
        case State.checkout_users(state) do
          {:ok, {:empty, state}} -> {:halt, {user_ids, state}}
          {:ok, {user_id, state}} -> {:cont, {[user_id | user_ids], state}}
        end
      end)

    case result do
      {:error, reason} ->
        {:reply,
         {:error, ErrorMessage.internal_server_error("failed to get user", %{reason: reason})},
         state}

      {user_ids, state} ->
        {:reply, user_ids, state}
    end
  end

  # API
  def checkin_user(id, name \\ @default_name) do
    IO.puts("New User #{id} has been checked in.")
    GenServer.cast(name, {:checkin_user, id})
  end

  def checkin_users(ids, name \\ @default_name) do
    GenServer.cast(name, {:checkin_users, ids})
  end

  def checkout_users(count, name \\ @default_name) do
    GenServer.call(name, {:checkout_users, count})
  end
end
