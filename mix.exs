defmodule Automaton.Mixfile do
  use Mix.Project

  def project do
    [app: :automaton,
     description: description(),
     package: package(),
     name: "Automaton",
     source_url: "https://github.com/flexnode/automaton",
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
    [{:excoveralls, "~> 0.7", only: :test}]
  end

  defp description do
    """
    Automaton is an Elixir library that manages the conversation between your chat bot and the user by maintaining the messages and context in a GenServer.

This is useful as most messaging platforms (webhooks) and NLP services (REST API) communicates with your backend in the typical Request/Response mode.

Automaton aims to be the glue/framework/library to help you focus on your backend instead of messing around with the plumbing of maintaining chat bots.
    """
  end

  defp package do
    [
      name: :automaton,
      files: ["lib", "mix.exs", "README*", "readme*", "LICENSE*", "license*"],
      maintainers: ["T.S. Lim"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/flexnode/automaton"}
    ]
  end
end
