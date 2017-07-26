defmodule Automaton.Conversation.MessageTest do
  use ExUnit.Case
  alias Automaton.Conversation.Message

  describe "build/5" do
    test "builds a message struct with values provided" do
      sender_id = "console"
      recipient = Automaton.Test.Bot
      message_text = "aloha"
      context = %{intent: "test"}
      sent_at = :os.system_time(:microsecond)

      message_struct = Message.build(sender_id, recipient, message_text, context, sent_at)

      assert message_struct.sender == sender_id
      assert message_struct.recipient == recipient
      assert message_struct.text == message_text
      assert message_struct.context == context
      assert message_struct.sent_at == sent_at
    end
  end
end
