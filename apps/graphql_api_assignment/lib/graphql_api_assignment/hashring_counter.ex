defmodule GraphqlApiAssignment.HashringCounter do
  @doc """
  I opted for the Hasring as I prefered avalaibility and partition tolerance
  over consistency (eventual consistency is fine for my use case). I wanted to
  avoid system downtime or refusal to serve requests.
  """
  use Task, restart: :permanent

  @hash_ring_name :default_hash_counter
  @ets_options [:public, :set, :named_table]
  @replica_count 2

  def hash_ring_name, do: @hash_ring_name

  def start_link(opts) do
    opts = Keyword.put_new(opts, :name, @hash_ring_name)

    Task.start_link(fn ->
      setup(opts)
    end)
  end

  defp setup(opts) do
    :ets.new(table_name(opts[:name]), @ets_options)
    Process.hibernate(Function, :identity, [])
  end

  def put(hash_ring \\ @hash_ring_name, key, _value \\ nil) do
    {duration, res} =
      :timer.tc(fn ->
        hash_ring
        |> key_to_node(key)
        |> Enum.each(
          &:erpc.cast(&1, fn ->
            hash_ring
            |> table_name()
            |> :ets.update_counter(key, {2, 1}, {key, 0})
          end)
        )
      end)

    GraphqlApiAssignment.Metrics.HashringCounter.inc_hash_ring_put_duration(duration)
    res
  end

  def get(hash_ring \\ @hash_ring_name, key) do
    {duration, res} =
      :timer.tc(fn ->
        hash_ring
        |> key_to_node(key)
        |> Enum.random()
        |> :erpc.call(fn ->
          res =
            hash_ring
            |> table_name()
            |> :ets.lookup(key)

          case res do
            [{_, value}] -> value
            _ -> 0
          end
        end)
      end)

    GraphqlApiAssignment.Metrics.HashringCounter.inc_hash_ring_get_duration(duration)
    res
  end

  def key_to_node(hash_ring \\ @hash_ring_name, key) do
    HashRing.Managed.key_to_nodes(hash_ring, key, @replica_count)
  end

  def table_name(hash_ring), do: :"#{hash_ring}_ets"

  @spec get_key_count(key :: atom()) :: integer()
  def get_key_count(key), do: get(hash_ring_name(), key)

  @spec increment_key(key :: atom()) :: :ok
  def increment_key(key), do: put(hash_ring_name(), key)
end
