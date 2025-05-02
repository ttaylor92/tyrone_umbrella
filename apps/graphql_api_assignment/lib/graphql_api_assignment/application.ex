defmodule GraphqlApiAssignment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [
          hosts: [
            :node1@localhost,
            :node2@localhost
          ]
        ]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: GraphqlApiAssignment.ClusterSupervisor]]},
      {Phoenix.PubSub, name: GraphqlApiAssignment.PubSub},
      {DNSCluster,
       query: Application.get_env(:graphql_api_assignment, :dns_cluster_query) || :ignore},
      # Start the Finch HTTP client for sending emails
      {Finch, name: GraphqlApiAssignment.Finch},
      # Start a worker by calling: GraphqlApiAssignment.Worker.start_link(arg)
      # {GraphqlApiAssignment.Worker, arg},
      GraphqlApiAssignment.RedixPool.child_spec(),
      # Start to serve requests, typically the last entry
      GraphqlApiAssignmentWeb.Endpoint,
      {Absinthe.Subscription, GraphqlApiAssignmentWeb.Endpoint},
      GraphqlApiAssignment.TokenCache,
      {PrometheusTelemetry,
       exporter: [enabled?: true, opts: [port: get_port("PROMETHEUS_PORT")]],
       metrics: [
         PrometheusTelemetry.Metrics.Ecto.metrics_for_repo(SchemasPG.Repo),
         PrometheusTelemetry.Metrics.GraphQL.metrics(),
         GraphqlApiAssignment.Metrics.TokenPipeline.metrics(),
         GraphqlApiAssignment.Metrics.HashringCounter.metrics()
       ]},
      GraphqlApiAssignment.SecurityClearanceQueue,
      GraphqlApiAssignment.ResourceScheduler,
      GraphqlApiAssignment.TokenPipelineSupervisor,
      %{
        id: :hashring_counter,
        start:
          {HashRing.Managed, :new,
           [
             GraphqlApiAssignment.HashringCounter.hash_ring_name(),
             [monitor_nodes: true, node_type: :visible]
           ]}
      },
      GraphqlApiAssignment.HashringCounter
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlApiAssignment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp get_port(k) do
    String.to_integer(System.get_env(k, "5000"))
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlApiAssignmentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
