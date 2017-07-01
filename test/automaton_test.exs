defmodule AutomatonTest do
  use ExUnit.Case
  alias Automaton.Conversation.Message

  describe "process/1" do
    test "starts a new conversation if no previous conversation found" do
      message = create_message()

      assert {:error, _} = Automaton.get_conversation("test")
      Automaton.process(message)

      {:ok, conversation} = Automaton.get_conversation("test")
      assert length(conversation.messages) == 1

      Automaton.terminate_conversation("test")
    end

    test "continues the previous conversation" do
      first_message = create_message()
      second_message = create_message(sent_at: :os.system_time(:seconds) + 1)

      Automaton.process(first_message)
      {:ok, conversation} = Automaton.get_conversation("test")

      assert length(conversation.messages) == 1
      assert conversation.session_id == "test"
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == first_message.sent_at

      Automaton.process(second_message)
      {:ok, conversation} = Automaton.get_conversation("test")

      assert length(conversation.messages) == 2
      assert conversation.session_id == "test"
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == second_message.sent_at

      Automaton.terminate_conversation("test")
    end
  end

  describe "get_conversation/1" do
    test "fails if no conversation exist with that session id" do
      assert  {:error, _} = Automaton.get_conversation("test")
    end

    test "retrieves an existing conversation" do
      message = create_message()
      Automaton.process(message)
      assert {:ok, _conversation} = Automaton.get_conversation("test")

      Automaton.terminate_conversation("test")
    end
  end

  describe "terminate_conversation/1" do
    test "fails if no conversation exist with that session id" do
      assert  {:error, _} = Automaton.terminate_conversation("test")
    end

    test "terminates an existing conversation" do
      message = create_message()
      Automaton.process(message)
      assert {:ok, _conversation} = Automaton.get_conversation("test")

      Automaton.terminate_conversation("test")
      assert {:error, _} = Automaton.get_conversation("test")
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
