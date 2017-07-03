defmodule Automaton.Adapter do
  @moduledoc """
  Defines an adapter and it's specifications
  """
  @type message :: Automaton.Conversation.Message.t
  @type response :: term
  @typep config :: Keyword.t

  @doc """
  Parses the webhook response into a Message
  """
  @callback parse(response) :: {:ok, message} | {:error, term}

  @doc """
  Sends a message to the messaging platform with the given config
  """
  @callback send(message, config) :: {:ok, message} | {:error, term}
end