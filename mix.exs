defmodule Automaton.Mixfile do
  use Mix.Project

  def project do
    [app: :automaton,
     description: "Elixir library to easily build and run ChatBots",
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     elixirc_paths: elixirc_paths(Mix.env),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [mod: {Automaton.Application, []},
      extra_applications: [:logger]]
  end

  defp deps do
    [{:plug, "~> 1.3.0"},
     {:excoveralls, "~> 0.7", only: :test}]
  end
end
