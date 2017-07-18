defmodule AutomatonTest do
  use ExUnit.Case
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  setup do
    adapter = Automaton.Adapters.Text
    bot = Test.Bot
    sender = :console
    session_id = Conversation.generate_session_id(bot, sender)

    on_exit fn ->
      Conversation.terminate(session_id)
    end

    %{bot: bot, adapter: adapter, sender: sender, session_id: session_id}
  end

  describe "converse/2" do
    test "returns a message as a reply", %{bot: bot, session_id: session_id} do
      assert {:error, _} = Conversation.get(session_id)

      {:ok, %Message{} = message} = Automaton.converse("aloha", bot)
      assert message.text == "aloha"

      assert {:ok, conversation} = Conversation.get(session_id)
      assert length(conversation.messages) == 2
    end
  end

  describe "receive/3" do
    test "parses message received and starts a conversation", %{bot: bot, adapter: adapter, session_id: session_id} do
      assert {:error, _} = Conversation.get(session_id)

      {:ok, %Message{} = message} = Automaton.receive("test", bot, adapter)
      assert message.text == "test"
      assert message.recipient == bot

      assert {:ok, conversation} = Conversation.get(session_id)
      assert length(conversation.messages) == 1
    end
  end

  describe "reply/4" do
    test "sends the message and adds it to the conversation", %{bot: bot, adapter: adapter, sender: sender, session_id: session_id} do
      assert {:error, _} = Conversation.get(session_id)

      received_message = %Message{text: "test receive", sender: sender, recipient: bot}
      Conversation.add_message(received_message, bot)

      message = %Message{text: "test reply", sender: bot, recipient: sender}

      {:ok, %Message{} = sent_message} = Automaton.reply(message, bot, adapter, %{})
      assert sent_message.text == message.text
      assert sent_message.sender == bot
      assert sent_message.recipient == sender

      assert {:ok, conversation} = Conversation.get(session_id)
      assert length(conversation.messages) == 1
    end
  end

end
