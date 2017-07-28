defmodule Automaton.BotTest do
  use ExUnit.Case, async: true

  describe "parse_config/2" do
    test "parses configuration from config file" do
      {otp_app, adapter, config} = Automaton.Bot.parse_config(Automaton.Test.Bot, [otp_app: :automaton])

      assert otp_app == :automaton
      assert adapter == Automaton.Adapters.Test
      assert config[:adapter] == Automaton.Adapters.Test
    end

    test "raises error if adapter configuration is missing" do
      assert_raise ArgumentError, fn ->
        Automaton.Bot.parse_config(Automaton.NoAdapter.Bot, [otp_app: :automaton])
      end
    end
  end
end
