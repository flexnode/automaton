defmodule Automaton.Adapters.FacebookMessenger do
  @moduledoc """
  Facebook Messenger Adapter
  """
  @behaviour Automaton.Adapter

  alias Automaton.Conversation.Message

  def parse(_response) do
    %Message{session_id: "123"}
  end

  def send(message, _config) do
    {:ok, message}
  end
end