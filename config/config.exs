use Mix.Config

import_config "#{Mix.env}.exs"

config :automaton, Echo.Bot,
          adapter: Automaton.Console.Adapter
