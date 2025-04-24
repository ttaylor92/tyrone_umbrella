defmodule GiphyScraper.Application do
  use Application

  @impl true
  def start(_start_type, _start_args) do
    children = [
      GiphyScraper.Repo
    ]

    opts = [strategy: :one_for_one, name: GiphyScraper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
