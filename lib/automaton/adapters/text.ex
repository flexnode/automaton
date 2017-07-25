defmodule Automaton.Adapters.Text do
  @moduledoc """
  Text Adapter for testing in console
  """
  @behaviour Automaton.Adapter

  def parse(text) do
    {:ok, :console, text, %{}}
  end

  def send(_sender_id, message, _context, _config) do
    IO.puts message
    :ok
  end
end