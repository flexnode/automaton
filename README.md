# Automaton

[![Build Status](https://semaphoreci.com/api/v1/tslim/automaton/branches/master/shields_badge.svg)](https://semaphoreci.com/tslim/automaton)

> Note: This library is still under heavy development.

Elixir library to easily build and run ChatBots.

## Quick Start

```elixir
# In your config/config.exs file
config :sample, Sample.Bot,
  adapter: Automaton.Adapters.Test

# In your application code

# Define your bot
defmodule Sample.Bot do
  use Automaton.Bot, otp_app: :sample

  # Echo backs whatever you said
  def process(incoming_message) do
    build_outgoing_message(recipient: incoming_message.sender,
                            text: incoming_message.text)
  end
end

# In an IEx session
Sample.Bot.converse("Hello World")
iex> {:ok,
 %Automaton.Conversation.Message{recipient: :console, sender: Sample.Bot,
  sent_at: 1499264553, session_id: {Sample.Bot, :console}, text: "Hello World"}}
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
Text (Testing)    | Automaton.Adapters.Text

Configure your adapter in `config/config.exs` file:

```elixir
config :sample, Sample.Bot,
  adapter: Automaton.Adapters.FacebookMessenger
  # adapter config (api keys, etc.)
```

You can also define custom adapters by implementing callbacks defined in
[adapter.ex](https://github.com/flexnode/automaton/blob/master/lib/automaton/adapter.ex)

## Documentation

More documentation can be found on [hexdocs](https://hex.pm/automaton). You can also find it in the source and it's accessible from iex.

## License

Plug source code is released under MIT License.
Check [LICENSE](https://github.com/flexnode/automaton/blob/master/LICENSE.md) file for more information.
