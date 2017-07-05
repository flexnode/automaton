defmodule Automaton do
  @moduledoc """
  Elixir library to easily build and run ChatBots.
  """
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  @doc """
  Converse with a bot and brain by sending a message
  """
  def converse(message, bot, brain) do
    with {:ok, received_message} <- bot.receive(message),
         {:ok, processed_message} <- brain.process(received_message),
         {:ok, sent_message} <- bot.reply(processed_message) do
      {:ok, sent_message}
    else
      error -> raise error
    end
  end

  @doc """
  Bot's receive callback. Parses the message and starts a conversation
  """
  def receive(message, bot, adapter) do
    with {:ok, parsed_message} <- parse_and_set_receipient(message, bot, adapter),
         {:ok, message} <- Conversation.add_message(parsed_message, bot) do
      {:ok, message}
    else
      error -> error
    end
  end

  @doc """
  Bot's reply callback. Sends the message and add it to the conversation
  """
  def reply(%Message{} = message, bot, adapter, config) do
    with {:ok, sent_message} <- adapter.send(message, config),
         {:ok, message} <- Conversation.add_message(sent_message, bot, sent_message.session_id) do
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
end
