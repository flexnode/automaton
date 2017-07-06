defmodule Automaton.Adapters.FacebookMessenger do
  @moduledoc """
  Facebook Messenger Adapter
  """
  @behaviour Automaton.Adapter

  require Logger

  alias Automaton.Conversation.Message

  def parse(response) do
    try do
      %{"entry" => [%{"messaging" => [message]}]} = response

      message = %Message{
        sender: get_in(message, ["sender", "id"]),
        text: get_in(message, ["message", "text"]),
        sent_at: get_in(message, ["timestamp"])
      }

      Logger.info("RECEIVED: #{inspect message}")
      {:ok, message}
    rescue
      _ ->
        {:error, "unable to parse message"}
    end
  end

  def send(message, _config) do
    Logger.info("SENT: #{inspect message}")
    {:ok, message}
  end
end