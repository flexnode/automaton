defmodule Automaton.Adapters.Console do
  @moduledoc """
  Facebook Messenger Adapter
  """
  @behaviour Automaton.Adapter

  require Logger
  alias Automaton.Conversation.Message

  def parse(text) do
    {:ok, %Message{text: text, sent_at: :os.system_time(:seconds)}}
  end

  def send(message, _config) do
    Logger.info("#{inspect message}")
    {:ok, message}
  end
end