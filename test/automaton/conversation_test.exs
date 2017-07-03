defmodule Automaton.ConversationTest do
  use ExUnit.Case
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  describe "add_message/1" do
    test "starts a new conversation if no previous conversation found" do
      message = create_message()

      assert {:error, _} = Conversation.get("test")
      assert {:ok, _} = Conversation.add_message(message)

      {:ok, conversation} = Conversation.get("test")
      assert length(conversation.messages) == 1

      Conversation.terminate("test")
    end

    test "continues the previous conversation" do
      first_message = create_message()
      second_message = create_message(sent_at: :os.system_time(:seconds) + 1)

      Conversation.add_message(first_message)
      {:ok, conversation} = Conversation.get("test")

      assert length(conversation.messages) == 1
      assert conversation.session_id == "test"
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == first_message.sent_at

      Conversation.add_message(second_message)
      {:ok, conversation} = Conversation.get("test")

      assert length(conversation.messages) == 2
      assert conversation.session_id == "test"
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == second_message.sent_at

      Conversation.terminate("test")
    end
  end

  describe "get_conversation/1" do
    test "fails if no conversation exist with that session id" do
      assert  {:error, _} = Conversation.get("test")
    end

    test "retrieves an existing conversation" do
      message = create_message()
      Conversation.add_message(message)
      assert {:ok, _conversation} = Conversation.get("test")

      Conversation.terminate("test")
    end
  end

  describe "terminate_conversation/1" do
    test "fails if no conversation exist with that session id" do
      assert  {:error, _} = Conversation.terminate("test")
    end

    test "terminates an existing conversation" do
      message = create_message()
      Conversation.add_message(message)
      assert {:ok, _conversation} = Conversation.get("test")

      Conversation.terminate("test")
      assert {:error, _} = Conversation.get("test")
    end
  end

  defp create_message(opts \\ []) do
    defaults = [text: "Hello World",
                session_id: "test",
                sent_at: :os.system_time(:seconds)]
    opts = Keyword.merge(defaults, opts)
    struct(Message, opts)
  end
end
