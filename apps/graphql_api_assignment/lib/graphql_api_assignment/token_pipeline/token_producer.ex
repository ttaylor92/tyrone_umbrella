defmodule GraphqlApiAssignment.TokenPipeline.TokenProducer do
  use GenStage
  alias GraphqlApiAssignment.SecurityClearanceQueue

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    GenStage.start_link(__MODULE__, %{}, opts)
  end

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, state) do
    IO.puts("#{demand} user id's demanded")
    users = SecurityClearanceQueue.checkout_users(demand)
    {:noreply, users, state}
  end

  def handle_cast({:dispatch, user_ids}, state) do
    {:noreply, user_ids, state}
  end

  def handle_cast({:new_user, user_id}, state) do
    # Immediately push new user to consumers
    {:noreply, [user_id], state}
  end

  def new_user_registered(user_id) do
    GenServer.cast(__MODULE__, {:new_user, user_id})
  end
end
