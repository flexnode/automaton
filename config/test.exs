use Mix.Config

config :automaton, Test.Bot,
          adapter: Automaton.Adapters.Text

config :automaton, Test.Brain,
          brain: Automaton.Brains.Echo