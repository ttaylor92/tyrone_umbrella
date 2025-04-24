defmodule GraphqlApiAssignment.TokenPipeline.TokenConsumer do
  use GenStage
  alias GraphqlApiAssignment.TokenPipeline

  @default_name __MODULE__

  def start_link(opts \\ []) do
    opts = Keyword.put_new(opts, :name, @default_name)
    {subscribe_to, opts} = Keyword.pop(opts, :subscribe_to, TokenPipeline.TokenProducer)
    GenStage.start_link(__MODULE__, [subscribe_to: subscribe_to], opts)
  end

  def init(state) do
    {:consumer, state,
     subscribe_to: [{Keyword.get(state, :subscribe_to), min_demand: 0, max_demand: 10}]}
  end

  def handle_events(user_tokens, _from, state) do
    IO.inspect("Consumer received #{length(user_tokens)} events")

    for {user_id, token} <- user_tokens do
      # Update Cache
      GraphqlApiAssignment.TokenCache.put(user_id, token)

      # Publish message
      Absinthe.Subscription.publish(
        GraphqlApiAssignmentWeb.Endpoint,
        token,
        user_auth_token: user_id
      )
    end

    {:noreply, [], state}
  end
end
