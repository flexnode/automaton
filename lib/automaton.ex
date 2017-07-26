defmodule Automaton do
  @moduledoc """
  Elixir library to easily build and run ChatBots.
  """
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  @doc """
  Converse with a bot by sending it a message
  """
  def converse(bot, message) do
    with {:ok, sender_id, message_text, context} <- bot.__adapter__.parse(message),
         parsed_message <- Message.build(sender_id, bot, message_text, context),
         session_id <- generate_session_id(bot, sender_id),
         {:ok, received_message} <- Conversation.add_message(session_id, parsed_message),
         :ok <- bot.process(received_message.sender, received_message.text, received_message.context) do
      :ok
    else
      error -> error
    end
  end

  @doc """
  Reply to the user and adds it to the conversation
  """
  def reply(bot, sender_id, message_text, context) do
    with :ok <- bot.__adapter__.send(sender_id, message_text, context, bot.__config__),
         sent_message <- Message.build(bot, sender_id, message_text, context),
         session_id <- generate_session_id(bot, sender_id),
         {:ok, _message} <- Conversation.add_message(session_id, sent_message) do
      :ok
    else
      error -> error
    end
  end

  defp generate_session_id(bot, sender), do: {bot, sender}
end
