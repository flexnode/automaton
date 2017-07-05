defmodule Automaton do
  @moduledoc """
  Elixir library to easily build and run ChatBots.
  """
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  def converse(message, bot, brain) do
    with {:ok, received_message} <- bot.receive(message),
         {:ok, processed_message} <- brain.process(received_message),
         {:ok, sent_message} <- bot.reply(processed_message) do
      {:ok, sent_message}
    else
      error -> raise error
    end
  end

  def receive(message, bot, adapter) do
    with {:ok, parsed_message} <- parse_and_set_receipient(message, bot, adapter),
         session_id <- generate_session_id(bot, parsed_message.sender),
         {:ok, message} <- Conversation.add_message(bot, session_id, parsed_message) do
      {:ok, message}
    else
      error -> error
    end
  end

  def reply(%Message{} = message, bot, adapter, config) do
    with {:ok, sent_message} <- adapter.send(message, config),
         session_id <- generate_session_id(bot, sent_message.receipient),
         {:ok, message} <- Conversation.add_message(bot, session_id, sent_message) do
      {:ok, message}
    else
      error -> error
    end
  end

  defp parse_and_set_receipient(message, bot, adapter) do
    with {:ok, parsed_message} <- adapter.parse(message) do
      {:ok, %{parsed_message | receipient: bot}}
    end
  end

  defp generate_session_id(bot, user), do: {bot, user}
end
