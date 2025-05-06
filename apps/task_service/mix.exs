defmodule TaskService.MixProject do
  use Mix.Project

  def project do
    [
      app: :task_service,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TaskService.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:oban, "~> 2.19"},
      {:igniter, "~> 0.5", only: [:dev]},
      {:schemas_pg, in_umbrella: true},
      {:giphy_scraper, in_umbrella: true}
    ]
  end
end
