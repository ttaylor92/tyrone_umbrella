defmodule TaskService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # SchemasPG.Repo,
      {Oban, TaskService.Config.oban()}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskService.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
