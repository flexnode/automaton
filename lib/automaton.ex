defmodule Automaton do
  @moduledoc """
  Elixir library to easily build and run ChatBots.
  """
  alias Automaton.Conversation

  def converse(message, bot, brain) do
    with {:ok, received_message} <- bot.receive(message),
         {:ok, processed_message} <- brain.process(received_message),
         {:ok, sent_message} <- bot.reply(processed_message) do
      {:ok, sent_message}
    else
      error -> raise error
    end
  end

  def receive(message, adapter) do
    with {:ok, parsed_message} <- adapter.parse(message),
         {:ok, _} <- Conversation.add_message(%{parsed_message | session_id: "test"}) do
      {:ok, parsed_message}
    else
      error -> error
    end
  end

  def reply(message, adapter, config) do
    with {:ok, sent_message} <- adapter.send(message, config),
         {:ok, _} <- Conversation.add_message(%{sent_message | session_id: "test"}) do
      {:ok, sent_message}
    else
      error -> error
    end
  end
end
