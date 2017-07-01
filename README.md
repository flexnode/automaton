# Automaton

> Note: This library is still under heavy development.

Elixir library to easily build and run ChatBots.

## Quick Start

```elixir
# In your config/config.exs file
config :sample, Sample.Bot,
  adapter: Automaton.Adapters.Test

# In your application code
defmodule Sample.Bot do
  use Automaton.Bot, otp_app: :sample
end

# In an IEx session
Sample.Bot.message("Hello World")
```

## Installation

Add Automaton in your `mix.exs` dependencies:

  ```elixir
  def deps do
    [{:automaton, "~> 0.1.0"}]
  end
  ```

## Adapters

Platform          | Automaton adapter
:-----------------| :------------------------
Facebook Messenger| Automaton.Adapters.FacebookMessenger
Telegram          | Automaton.Adapters.Telegram
Slack             | Automaton.Adapters.Slack
Test              | Automaton.Adapters.Test

Configure your adapter in `config/config.exs` file:

```elixir
config :sample, Sample.Bot,
  adapter: Automaton.Adapters.FacebookMessenger
  # adapter config (api keys, etc.)
```

You can also define custom adapters by implementation callbacks defined in
[adapter.ex](https://github.com/flexnode/automaton/blob/master/lib/automaton/adapter.ex)

## Brains

Platform        | Automaton adapter
:---------------| :------------------------
Echo            | Automaton.Brains.Echo
Wit.ai          | Automaton.Brains.WitAi
Api.ai          | Automaton.Brains.ApiAi


## Phoenix Integration

If you are using Phoenix, you can forward your webhook response to the bot.

```elixir
# In your router.ex
forward "/bot/webhook", Sample.Bot
```

## Documentation

More documentation can be found on [hexdocs](https://hex.pm/automaton). You can also find it in the source and it's accessible from iex.

## License

Plug source code is released under MIT License.
Check [LICENSE](https://github.com/flexnode/automaton/blob/master/LICENSE.md) file for more information.