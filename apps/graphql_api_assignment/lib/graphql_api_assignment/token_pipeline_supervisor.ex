defmodule GraphqlApiAssignment.TokenPipelineSupervisor do
  use Supervisor

  @default_name __MODULE__

  def start_link(opts \\ []) do
    {prefix, opts} = Keyword.pop(opts, :prefix, :default)
    options = Keyword.put_new(opts, :name, @default_name)
    Supervisor.start_link(__MODULE__, prefix, options)
  end

  # @impl true
  def init(prefix) do
    prefix
    |> children()
    |> Supervisor.init(strategy: :rest_for_one)
  end

  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      type: :supervisor
    }
  end

  defp children(prefix) do
    [
      {GraphqlApiAssignment.TokenPipeline.TokenProducer,
       [name: get_name(prefix, :token_producer)]},
      {GraphqlApiAssignment.TokenPipeline.TokenProducerConsumer,
       [
         name: get_name(prefix, :token_producer_consumer),
         subscribe_to: get_name(prefix, :token_producer)
       ]},
      {GraphqlApiAssignment.TokenPipeline.TokenConsumer,
       [
         name: get_name(prefix, :token_consumer),
         subscribe_to: get_name(prefix, :token_producer_consumer)
       ]}
    ]
  end

  defp get_name(prefix, postfix) when is_atom(prefix) do
    String.to_atom(Atom.to_string(prefix) <> "_" <> Atom.to_string(postfix))
  end

  defp get_name(prefix, postfix) when is_binary(prefix) do
    String.to_atom(prefix <> "_" <> Atom.to_string(postfix))
  end

  defp get_name(_prefix, _postfix) do
    raise "Prefix must be either atom or binary"
  end
end
