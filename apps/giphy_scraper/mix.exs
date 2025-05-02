defmodule GiphyScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :giphy_scraper,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {GiphyScraper.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:swoosh, "~> 1.5"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:phoenix_pubsub, "~> 2.0"},
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0"},
      {:faker, "~> 0.18", only: :test},
      {:dataloader, "~> 1.0.0"},
      {:gen_stage, "~> 1.2.1"},
      {:libcluster, "~> 3.3"},
      {:prometheus_telemetry, "~> 0.4"},
      {:castore, "~> 1.0"},
      {:schemas_pg, in_umbrella: true},

      {:req, []},
      {:ecto_sql, []},
      {:postgrex, []},
      {:ecto_shorts, []}
    ]
  end
end
