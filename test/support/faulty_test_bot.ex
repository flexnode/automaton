defmodule Automaton.FaultyTest.Bot do
  use Automaton.Bot, otp_app: :automaton

  def process(sender_id, message_text, context) do
    :ok
  end
end