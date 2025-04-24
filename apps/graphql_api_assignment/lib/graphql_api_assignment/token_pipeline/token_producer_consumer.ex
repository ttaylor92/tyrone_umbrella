defmodule GraphqlApiAssignment.TokenPipeline.TokenProducerConsumer do
  use GenStage
  alias GraphqlApiAssignment.TokenPipeline
  alias GraphqlApiAssignment.Metrics

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    {subscribe_to, opts} = Keyword.pop(opts, :subscribe_to, TokenPipeline.TokenProducer)
    GenStage.start_link(__MODULE__, [subscribe_to: subscribe_to], opts)
  end

  def init(state) do
    {:producer_consumer, state,
     subscribe_to: [{Keyword.get(state, :subscribe_to), min_demand: 0, max_demand: 10}]}
  end

  def handle_events(users, _from, state) do
    user_tokens =
      Enum.map(users, fn user_id ->
        token = generate_token(user_id)
        {user_id, token}
      end)

    {:noreply, user_tokens, state}
  end

  defp generate_token(user_id) do
    Metrics.TokenPipeline.inc_total_count()

    {duration, res} =
      :timer.tc(fn ->
        16
        |> :crypto.strong_rand_bytes()
        |> Base.encode64()
        |> Kernel.<>("#{user_id}")
      end)

    Metrics.TokenPipeline.inc_generate_session_token(duration)

    res
  end
end
