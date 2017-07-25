defmodule Automaton.Adapter do
  @moduledoc """
  Defines an adapter and it's specifications
  """
  @type sender_id :: String.t
  @type message_text :: String.t
  @type context :: Map.t
  @typep response :: term
  @typep config :: Keyword.t

  @doc """
  Parses the webhook response into a Message
  """
  @callback parse(response) :: {:ok, sender_id, message_text, context} | {:error, term}

  @doc """
  Sends a message to the messaging platform with the given config
  """
  @callback send(sender_id, message_text, context, config) :: :ok | {:error, term}
end