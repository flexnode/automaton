defmodule Automaton.Brains.Echo do
  @moduledoc """
  A brain that just echoes back whatever you said
  """
  @behaviour Automaton.Bot.Brain

  alias Automaton.Conversation.Message

  def process(%Message{text: text, receipient: receipient, sender: sender} = message, _config) do
    {:ok, %{message | text: text, receipient: sender, sender: receipient}}
  end

end