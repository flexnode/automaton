defmodule Automaton do
  @moduledoc """
  Service to manage Automaton conversations.

  Integrates with messaging platform like Facebook Messenger.

  Leverages services like Wit.ai for NLP
  """

  alias Automaton.Conversation.Message

  @registry Automaton.Registry

  @doc """
  Process an incoming message
  """
  def process(%Message{session_id: session_id} = message) do
    case lookup_conversation(session_id) do
      nil ->
        start_conversation(message)
      pid ->
        continue_conversation(pid, message)
    end
  end

  @doc """
  Get a conversation and it's messages using it's session id
  """
  def get_conversation(session_id) do
    case lookup_conversation(session_id) do
      nil ->
        {:error, :conversation_not_found}
      pid ->
        {:ok, Automaton.Conversation.get_info(pid)}
    end
  end

  @doc """
  Ends a conversation
  """
  def terminate_conversation(session_id) do
    case lookup_conversation(session_id) do
      nil ->
        {:error, :conversation_not_found}
      pid ->
        {:ok, Automaton.Conversation.stop(pid)}
    end
  end

  defp start_conversation(%Message{session_id: session_id} = message) do
    Supervisor.start_child(Automaton.Conversation.Supervisor,
                            [message, [name: via_tuple(session_id)]])
  end

  defp lookup_conversation(session_id) do
    case Registry.lookup(@registry, session_id) do
      [] -> nil
      [{pid, _}] -> pid
    end
  end

  defp continue_conversation(pid, message) do
    Automaton.Conversation.add_message(pid, message)
  end

  defp via_tuple(key) do
    {:via, Registry, {@registry, key}}
  end
end
