use Mix.Config

config :logger, level: :warn

config :automaton, Automaton.Test.Bot,
          adapter: Automaton.Adapters.Test

config :automaton, Automaton.FaultyTest.Bot,
          adapter: Automaton.Adapters.FaultyTest

config :automaton, Automaton.NoAdapter.Bot,
          not_adapter: "nope"
