# Automaton  [![Hex.pm](https://img.shields.io/hexpm/v/automaton.svg)](https://hex.pm/packages/automaton) [![Build Status](https://semaphoreci.com/api/v1/tslim/automaton/branches/master/shields_badge.svg)](https://semaphoreci.com/tslim/automaton) [![Coverage Status](https://coveralls.io/repos/github/flexnode/automaton/badge.svg?branch=master)](https://coveralls.io/github/flexnode/automaton?branch=master)

> Note: This library is still under heavy development.

Automaton is an Elixir library that manages the conversation between your chat bot and the user by maintaining the messages and context in a GenServer.

This is useful as most messaging platforms (webhooks) and NLP services (REST API) communicates with your backend in the typical Request/Response mode.

Automaton aims to be the glue/framework/library to help you focus on your backend instead of messing around with the plumbing of maintaining chat bots.

## Quick Start

```elixir
# In your config/config.exs file
config :sample, Sample.Bot,
  adapter: Automaton.Console.Adapter

# In your application code

# Define your bot
defmodule Sample.Bot do
  use Automaton.Bot, otp_app: :sample

  # Echo backs whatever you said
  def process(sender_id, message, context) do
    reply(sender_id, message, context)
  end
end

# In an IEx session
iex> Sample.Bot.converse("Hello World")
Hello World
:ok
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
Facebook Messenger| [Automaton.FacebookMessenger.Adapter](https://github.com/flexnode/automaton_fb_messenger)
Telegram          | Automaton.Telegram.Adapter
Slack             | Automaton.Slack.Adapter
Console (Included)| Automaton.Console.Adapter

Configure your adapter in `config/config.exs` file:

```elixir
config :sample, Sample.Bot,
  adapter: Automaton.FacebookMessenger.Adapter
  # adapter config (api keys, etc.)
```

You can also define custom adapters by implementing callbacks defined in
[adapter.ex](https://github.com/flexnode/automaton/blob/master/lib/automaton/adapter.ex)

## Proposed Roadmap
- [x] Stores conversation message and context
- [x] Adapter layer to support different messaging platforms
- [x] Simple callback to process messages/context
- [ ] Access to conversation context
- [ ] Terminates stale conversation and logs it
- [ ] Callback for conversation termination for custom behavior
- [ ] Tracks simple metrics like conversation/messages counts

## Documentation

More documentation can be found on [hexdocs](https://hex.pm/automaton). You can also find it in the source and it's accessible from iex.

## License

Plug source code is released under MIT License.
Check [LICENSE](https://github.com/flexnode/automaton/blob/master/LICENSE.md) file for more information.
