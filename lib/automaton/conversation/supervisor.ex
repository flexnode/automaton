defmodule Automaton.Conversation.Supervisor do
  use Supervisor

  def start_link(_opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Automaton.Conversation.Server, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end