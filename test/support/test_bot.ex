defmodule Automaton.Test.Bot do
  use Automaton.Bot, otp_app: :automaton

  def process(sender_id, message_text, context) do
    send self(), {:process, sender_id, message_text, context}
    reply(sender_id, message_text, context)
  end
end