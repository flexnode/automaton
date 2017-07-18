defmodule Test.Bot do
  use Automaton.Bot, otp_app: :automaton
  alias Automaton.Conversation.Message

  def process(%Message{text: text, recipient: recipient, sender: sender} = message) do
    {:ok, %{message | text: text, recipient: sender, sender: recipient}}
  end
end