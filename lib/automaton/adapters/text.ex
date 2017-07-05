defmodule Automaton.Adapters.Text do
  @moduledoc """
  Text Adapter for testing in console
  """
  @behaviour Automaton.Adapter

  alias Automaton.Conversation.Message

  def parse(text) do
    message = %Message{text: text,
                    sender: :console,
                    sent_at: :os.system_time(:seconds)}

    {:ok, message}
  end

  def send(message, _config) do
    {:ok, message}
  end
end