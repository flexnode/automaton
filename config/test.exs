use Mix.Config

config :automaton, Automaton.Test.Bot,
          adapter: Automaton.Adapters.Test

config :automaton, Automaton.FaultyTest.Bot,
          adapter: Automaton.Adapters.FaultyTest

config :automaton, Automaton.NoAdapter.Bot,
          not_adapter: "nope"
