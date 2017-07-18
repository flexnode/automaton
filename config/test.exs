use Mix.Config

config :logger, level: :warn

config :automaton, Test.Bot,
          adapter: Automaton.Adapters.Text
