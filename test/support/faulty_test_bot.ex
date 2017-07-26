defmodule Automaton.FaultyTest.Bot do
  use Automaton.Bot, otp_app: :automaton

  def process(_sender_id, _message_text, _context) do
    :ok
  end
end