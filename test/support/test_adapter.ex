defmodule Automaton.Adapters.Test do
  @moduledoc """
  Test Adapter
  """
  @behaviour Automaton.Adapter

  def parse(text) do
    send self(), {:parse, text}
    {:ok, "test", text, %{}}
  end

  def send(sender_id, message_text, context, config) do
    send self(), {:send, sender_id, message_text, context, config}
    :ok
  end
end