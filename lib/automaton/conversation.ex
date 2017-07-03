defmodule Automaton.Conversation do
  @moduledoc """
  Module to manage Automaton conversations.
  """

  alias Automaton.Conversation.Message

  @registry Automaton.Registry

  @doc """
  Adds a message to the conversation
  """
  def add_message(%Message{session_id: session_id} = message) do
    case lookup(session_id) do
      nil ->
        start_new_conversation(message)
      pid ->
        resume_existing_conversation(pid, message)
    end
  end

  @doc """
  Get a conversation and it's messages using it's session id
  """
  def get(session_id) do
    case lookup(session_id) do
      nil ->
        {:error, :conversation_not_found}
      pid ->
        {:ok, Automaton.Conversation.Server.get_info(pid)}
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
        {:ok, Automaton.Conversation.Server.stop(pid)}
    end
  end

  defp start_new_conversation(%Message{session_id: session_id} = message) do
    Supervisor.start_child(Automaton.Conversation.Supervisor,
                            [message, [name: via_tuple(session_id)]])
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

  defp via_tuple(key) do
    {:via, Registry, {@registry, key}}
  end
end
