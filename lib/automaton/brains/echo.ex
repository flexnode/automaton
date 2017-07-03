defmodule Automaton.Brains.Echo do
  @moduledoc """
  A brain that just echoes back whatever you said
  """
  @behaviour Automaton.Bot.Brain

  alias Automaton.Conversation.Message

  def process(%Message{text: text, receipient: receipient, sender: sender}, _config) do
    {:ok, %Message{text: text, receipient: sender, sender: receipient}}
  end

end