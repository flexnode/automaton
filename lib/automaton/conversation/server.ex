defmodule Automaton.Conversation.Server do
  use GenServer
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  @doc """
  Starts a new conversation with the initial message
  """
  def start_link(bot, session_id, message, opts \\ []) do
    GenServer.start_link(__MODULE__, {bot, session_id, message}, opts)
  end

  @doc """
  Initialize the conversation state
  """
  def init({bot, session_id, %Message{} = message}) do
    state = init_state(bot, session_id, message)
    {:ok, state}
  end

  @doc """
  Get conversation info
  """
  def get_info(pid) do
    GenServer.call(pid, {:info})
  end

  @doc """
  Adds a message to the conversation
  """
  def add_message(pid, %Message{} = message) do
    GenServer.call(pid, {:add_message, message})
  end

  @doc """
  Get the last message in the conversation
  """
  def last_message(pid) do
    GenServer.call(pid, {:last_message})
  end

  @doc """
  Stop current conversation and clean up
  """
  def stop(pid, reason \\ :normal, timeout \\ :infinity) do
    GenServer.stop(pid, reason, timeout)
  end

  ### Callbacks ###

  def handle_call({:info}, _from, conversation) do
    {:reply, conversation, conversation}
  end

  def handle_call({:add_message, %Message{} = message}, _from, conversation) do
    new_conversation =
      conversation
      |> add_message_to_conversation(message)

    message = get_last_message(new_conversation)

    {:reply, {:ok, message}, new_conversation}
  end

  def handle_call({:last_message}, _from, conversation) do
    {:reply, get_last_message(conversation), conversation}
  end

  def terminate(_reason, _state) do
    # Persist to log for storage
  end

  defp init_state(bot, session_id, %Message{} = message) do
    %Conversation{session_id: session_id, bot: bot}
    |> add_message_to_conversation(message)
  end

  defp add_message_to_conversation(%Conversation{} = conversation, %Message{sent_at: sent_at} = message) do
    conversation
    |> add_to_messages(message)
    |> set_started_at(sent_at)
    |> set_last_message_at(sent_at)
  end

  defp add_to_messages(conversation, message) do
    message = %{message | session_id: conversation.session_id}
    %{conversation | messages: [message | conversation.messages]}
  end

  defp set_started_at(conversation, timestamp) do
    case conversation.started_at do
      nil -> %{conversation | started_at: timestamp}
      _ -> conversation
    end
  end

  defp set_last_message_at(conversation, timestamp) do
    %{conversation | last_message_at: timestamp}
  end

  defp get_last_message(conversation) do
    [last_message | _messages] = conversation.messages
    last_message
  end
end