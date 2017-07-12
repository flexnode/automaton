defmodule Automaton.Brains.Echo do
  @moduledoc """
  A brain that just echoes back whatever you said
  """
  @behaviour Automaton.Bot.Brain

  alias Automaton.Conversation.Message

  def process(%Message{text: text, recipient: recipient, sender: sender} = message, _config) do
    {:ok, %{message | text: text, recipient: sender, sender: recipient}}
  end

end