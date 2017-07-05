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
     elixirc_paths: elixirc_paths(Mix.env)]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [mod: {Automaton.Application, []},
      extra_applications: [:logger]]
  end

  defp deps do
    [{:plug, "~> 1.3.0"}]
  end
end
