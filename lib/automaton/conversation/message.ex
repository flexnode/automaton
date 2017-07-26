defmodule Automaton.Conversation.Message do
  @moduledoc """
  Represents a message in a conversation
  """
  alias Automaton.Conversation.Message

  defstruct session_id: nil,
            sender: nil,
            recipient: nil,
            text: "",
            context: %{},
            sent_at: nil

  def build(sender_id, recipient, message_text, context \\ %{}, sent_at \\ System.os_time(:microsecond)) do
    %Message{sender: sender_id,
              recipient: recipient,
              text: message_text,
              context: context,
              sent_at: sent_at
    }
  end
end