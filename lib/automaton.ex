defmodule Automaton do
  @moduledoc """
  Elixir library to easily build and run ChatBots.
  """
  alias Automaton.Conversation

  def converse(message, bot, brain) do
    with {:ok, parsed_message} <- bot.parse(message),
         {:ok, _} <- Conversation.add_message(%{parsed_message | session_id: "test"}),
         {:ok, processed_message} <- brain.process(parsed_message),
         {:ok, _} <- Conversation.add_message(%{processed_message | session_id: "test"}),
         {:ok, sent_message} <- bot.send(processed_message) do
      {:ok, sent_message}
    else
      error -> raise error
    end
  end
end
