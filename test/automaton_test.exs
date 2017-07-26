defmodule AutomatonTest do
  use ExUnit.Case
  alias Automaton.Conversation

  setup do
    bot = Automaton.Test.Bot
    sender = "test"
    session_id = {bot, sender}

    on_exit fn ->
      Conversation.terminate(session_id)
    end

    %{bot: bot, sender: sender, session_id: session_id}
  end

  describe "converse/2" do
    test "parses the message, stores it in the conversation and send to bot for processing", %{bot: bot, sender: sender, session_id: session_id} do
      assert {:error, _} = Conversation.get(session_id)
      message = "aloha"

      Automaton.converse(bot, message)
      assert_receive {:parse, ^message}
      assert_receive {:process, ^sender, ^message, %{}}
      assert_receive {:send, ^sender, ^message, %{}, [adapter: Automaton.Adapters.Test]}

      assert {:ok, conversation} = Conversation.get(session_id)
      assert length(conversation.messages) == 2
    end

    test "returns error if any of the steps failed" do
      faulty_bot = Automaton.FaultyTest.Bot
      assert {:error, _message} = Automaton.converse(faulty_bot, "aloha")
    end
  end

  describe "reply/4" do
    test "sends the message and adds it to the conversation", %{bot: bot, sender: sender, session_id: session_id} do
      assert {:error, _} = Conversation.get(session_id)
      message = "aloha"

      Automaton.reply(bot, sender, message, %{})
      assert_receive {:send, ^sender, ^message, %{}, [adapter: Automaton.Adapters.Test]}

      assert {:ok, conversation} = Conversation.get(session_id)
      assert length(conversation.messages) == 1
    end

    test "returns error if any of the steps failed", %{sender: sender} do
      faulty_bot = Automaton.FaultyTest.Bot
      assert {:error, _message} = Automaton.reply(faulty_bot, sender, "aloha", %{})
    end
  end

end
