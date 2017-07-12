defmodule Automaton.Conversation.Message do
  @moduledoc """
  Represents a message in a conversation
  """

  defstruct session_id: nil,
            sender: nil,
            recipient: nil,
            text: "",
            sent_at: nil
end