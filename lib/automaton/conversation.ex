defmodule Automaton.Conversation do
  @moduledoc """
  Module to manage Automaton conversations.
  """

  @doc """
  Represents a conversation between a user and the bot.
  """
  defstruct session_id: nil,
            messages: [],
            started_at: nil,
            last_message_at: nil,
            bot: nil

  alias Automaton.Conversation.Message
  alias Automaton.Conversation.Server

  @registry Automaton.Registry

  @doc """
  Adds a message to the conversation.
  Automatically starts a new conversation or resumes an existing one
  """
  def add_message(bot, session_id, %Message{} = message) do
    case lookup(session_id) do
      nil ->
        start_new_conversation(bot, session_id, message)
      pid ->
        resume_existing_conversation(pid, message)
    end
  end

  @doc """
  Get a conversation and it's messages
  """
  def get(session_id) do
    case lookup(session_id) do
      nil ->
        {:error, :conversation_not_found}
      pid ->
        {:ok, Server.get_info(pid)}
    end
  end

  @doc """
  Get the last message from a conversation
  """
  def last_message(session_id) do
    case lookup(session_id) do
      nil ->
        {:error, :conversation_not_found}
      pid ->
        Server.last_message(pid)
    end
  end

  @doc """
  Ends a conversation
  """
  def terminate(session_id) do
    case lookup(session_id) do
      nil ->
        {:error, :conversation_not_found}
      pid ->
        {:ok, Server.stop(pid)}
    end
  end

  defp start_new_conversation(bot, session_id, message) do
    with {:ok, pid} <- start_server(bot, session_id, message),
         message <- Server.last_message(pid) do
      {:ok, message}
    end
  end

  defp start_server(bot, session_id, message) do
    Supervisor.start_child(Automaton.Conversation.Supervisor,
                            [bot,
                              session_id,
                              message,
                              [name: via_tuple(session_id)]
                            ]
                          )
  end

  defp lookup(session_id) do
    case Registry.lookup(@registry, session_id) do
      [] -> nil
      [{pid, _}] -> pid
    end
  end

  defp resume_existing_conversation(pid, message) do
    Automaton.Conversation.Server.add_message(pid, message)
  end

  defp via_tuple(session_id) do
    {:via, Registry, {@registry, session_id}}
  end
end
