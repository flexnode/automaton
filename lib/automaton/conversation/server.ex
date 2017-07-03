defmodule Automaton.Conversation.Server do
  @moduledoc """
  Represents a conversation between a user and the bot.
  """

  defstruct session_id: nil,
            messages: [],
            started_at: nil,
            last_message_at: nil

  use GenServer
  alias Automaton.Conversation.Message

  @doc """
  Starts a new conversation with the initial message
  """
  def start_link(message, opts \\ []) do
    GenServer.start_link(__MODULE__, message, opts)
  end

  @doc """
  Initialize the conversation state
  """
  def init(%Message{} = message) do
    state = init_state(message)
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
  Stop current conversation and clean up
  """
  def stop(pid, reason \\ :normal, timeout \\ :infinity) do
    GenServer.stop(pid, reason, timeout)
  end

  ### Callbacks ###

  def handle_call({:info}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add_message, %Message{sent_at: sent_at} = message}, _from, state) do
    {:reply,
      {:ok, message},
      %{state | messages: [message | state.messages], last_message_at: sent_at}
    }
  end

  def terminate(_reason, _state) do
    # Persist to log for storage
  end

  defp init_state(%Message{session_id: session_id, sent_at: sent_at} = message) do
    %__MODULE__{
      session_id: session_id,
      messages: [message],
      started_at: sent_at,
      last_message_at: sent_at
    }
  end
end