defmodule Automaton.Adapters.FaultyTest do
  @moduledoc """
  Faulty Test Adapter to test error state
  """
  @behaviour Automaton.Adapter

  def parse(text) do
    send self(), {:parse, text}
    {:error, "this adapter is faulty"}
  end

  def send(sender_id, message_text, context, config) do
    send self(), {:send, sender_id, message_text, context, config}
    {:error, "this adapter is faulty"}
  end
end