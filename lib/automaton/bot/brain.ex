defmodule Automaton.Bot.Brain do
  @moduledoc """
  Defines a bot's brain and it's specifications

  When used, the brain expects `:otp_app` as an option.
  The `:otp_app` should point to an OTP application that has the brain
  configuration. For example, the brain:

    defmodule Sample.Bot.Brain do
      use Automaton.Bot.Brain, otp_app: :sample
    end

  Could be configured with:

    config :sample, Sample.Bot.Brain,
      brain: Automaton.Brains.WitAi,
      token: "XYZ"

  Most of the configuration that goes into the config is specific to
  the brain, so check the brain's documentation for more information.

  Note that the configuration is set into your bot at compile time.
  If you need to reference config at runtime you can use a tuple like
  `{:system, "ENV_VAR"}`.

    config :sample, Sample.Bot.Brain,
      brain: Automaton.Brains.WitAi,
      token: {:system, "WIT_AI_TOKEN"}
  """

  @type message :: Automaton.Conversation.Message.t
  @typep config :: Keyword.t

  @doc """
  Processes the message and returns a text response
  """
  @callback process(message, config) :: {:ok, String.t} | {:error, term}

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do

      {otp_app, brain, config} = Automaton.Bot.Brain.parse_config(__MODULE__, opts)

      @brain brain
      @config config

      def __brain__, do: @brain

      def process(message) do
        @brain.process(message, @config)
      end
    end
  end

  @doc """
  Parses the OTP configuration at compile time.
  """
  def parse_config(bot, opts) do
    otp_app = Keyword.fetch!(opts, :otp_app)
    config = Application.get_env(otp_app, bot, [])
    brain = opts[:brain] || config[:brain]

    unless brain do
      raise ArgumentError, "missing :brain configuration in " <>
                           "config #{inspect opts}, #{inspect bot}"
    end

    {otp_app, brain, config}
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