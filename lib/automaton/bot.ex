defmodule Automaton.Bot do
  @moduledoc """
  Defines a bot.

  Acts as a wrapper around an messaging adapter to make it easy to swap
  adapters without having to change your code.

  When used, the bot expects `:otp_app` as an option.
  The `:otp_app` should point to an OTP application that has the bot
  configuration. For example, the bot:

    defmodule Sample.Bot do
      use Automaton.Bot, otp_app: :sample

      ...
    end

  Could be configured with:

    config :sample, Sample.Bot,
      adapter: Automaton.Adapters.FacebookMessenger,
      access_token: "XYZ"

  Most of the configuration that goes into the config is specific to
  the adapter, so check the adapter's documentation for more information.

  Note that the configuration is set into your bot at compile time.
  If you need to reference config at runtime you can use a tuple like
  `{:system, "ENV_VAR"}`.

    config :sample, Sample.Bot,
      adapter: Automaton.Adapters.FacebookMessenger,
      access_token: {:system, "FB_MESSENGER_TOKEN"}

  This will forward responses to the bot which will then parse it
  using the adapter configured and start a conversation.
  """

  @type sender_id :: String.t
  @type message_text :: String.t
  @type context :: Map.t

  @doc """
  Callback to handle an incoming message
  """
  @callback process(sender_id, message_text, context) :: :ok | {:error, term}

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do

      {otp_app, adapter, config} = Automaton.Bot.parse_config(__MODULE__, opts)

      require Logger

      @behaviour Automaton.Bot

      @adapter adapter
      @config config

      def __adapter__, do: @adapter

      def __config__, do: @config

      def converse(message) do
        Automaton.converse(__MODULE__, message)
      end

      def reply(sender_id, message_text, context) do
        Automaton.reply(__MODULE__, sender_id, message_text, context)
      end
    end
  end

  @doc """
  Parses the OTP configuration at compile time.
  """
  def parse_config(bot, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    config = Application.get_env(otp_app, bot, [])
    adapter = opts[:adapter] || config[:adapter]

    unless adapter do
      raise ArgumentError, "missing :adapter configuration in " <>
                           "config #{inspect otp_app}, #{inspect bot}"
    end

    {otp_app, adapter, config}
  end

  @doc """
  Parses the OTP configuration at run time.
  This function will transform all the {:system, "ENV_VAR"} tuples into their
  respective values grabbed from the process environment.
  """
  def parse_runtime_config(config) do
    Enum.map config, fn
      {key, {:system, env_var}} -> {key, System.get_env(env_var)}
      {key, value} -> {key, value}
    end
  end
end