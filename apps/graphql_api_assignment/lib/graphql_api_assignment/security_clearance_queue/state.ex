defmodule GraphqlApiAssignment.SecurityClearanceQueue.State do
  defstruct [:user_queue]

  def new do
    struct!(__MODULE__, %{user_queue: :queue.new()})
  end

  def checkin_user(%_{user_queue: user_queue} = state, id) do
    {:ok, %{state | user_queue: :queue.in(id, user_queue)}}
  end

  def checkin_users(%_{user_queue: user_queue} = state, ids) do
    queue = Enum.reduce(ids, user_queue, fn x, acc -> :queue.in(x, acc) end)
    {:ok, %{state | user_queue: queue}}
  end

  def checkout_users(%_{user_queue: user_queue} = state) do
    case :queue.out(user_queue) do
      {{:value, id}, user_queue} -> {:ok, {id, %{state | user_queue: user_queue}}}
      {:empty, user_queue} -> {:ok, {:empty, %{state | user_queue: user_queue}}}
    end
  end

  def queued_users(%_{user_queue: user_queue} = _state) do
    {:ok, :queue.to_list(user_queue)}
  end
end
