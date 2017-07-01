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
    end

  Could be configured with:

    config :sample, Sample.Bot,
      adapter: Automaton.Adapters.FacebookMessenger,
      access_token: "XYZ"

  Most of the configuration that goes into the config is specific to
  the adapter, so check the adapter's documentation for more information.

  Note that the configuration is set into your messenger at compile time.
  If you need to reference config at runtime you can use a tuple like
  `{:system, "ENV_VAR"}`.

    config :sample, Sample.Bot,
      adapter: Automaton.Adapters.FacebookMessenger,
      version: {:system, "FB_MESSENGER_API_VER"}

  Once configured, you can use the adapter in your router/endpoints:

    forward "/webhook/messenger", Sample.Bot

  This will forward responses to the messenger which will then parse it
  using the adapter configured and start a conversation.
  """
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do

      {otp_app, adapter, config} = Automaton.Bot.parse_config(__MODULE__, opts)

      import Plug.Conn, only: [send_resp: 3]
      @behaviour Plug

      @adapter adapter
      @config config

      def __adapter__, do: @adapter

      def init(default), do: default

      def call(conn, params) do
        params
        |> parse
        |> Automaton.process

        send_resp(conn, 200, "Success")
      end

      def parse(response) do
        message = @adapter.parse(response)
        %{message | messenger: __MODULE__}
      end

      def send(%Automaton.Conversation.Message{} = message, config) do
        config =
          @config
          |> Keyword.merge(config)
          |> Automaton.Messenger.parse_runtime_config()

        @adapter.send(message, config)
      end

      def send(message, _config) do
        raise ArgumentError, "expected %Automaton.Conversation.Message{}, got #{inspect message}"
      end
    end
  end

  @doc """
  Parses the OTP configuration at compile time.
  """
  def parse_config(messenger, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    config = Application.get_env(otp_app, messenger, [])
    adapter = opts[:adapter] || config[:adapter]

    unless adapter do
      raise ArgumentError, "missing :adapter configuration in " <>
                           "config #{inspect otp_app}, #{inspect messenger}"
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