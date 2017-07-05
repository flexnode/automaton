defmodule Automaton.ConversationTest do
  use ExUnit.Case
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  setup do
    session_id = "test"

    on_exit fn ->
      Conversation.terminate(session_id)
    end

    %{bot: __MODULE__, session_id: session_id}
  end

  describe "add_message/1" do
    test "starts a new conversation if no previous conversation found", %{bot: bot, session_id: session_id} do
      message = create_message()

      assert {:error, _} = Conversation.get(session_id)
      assert {:ok, _} = Conversation.add_message(bot, session_id, message)

      {:ok, conversation} = Conversation.get(session_id)
      assert length(conversation.messages) == 1
    end

    test "continues the previous conversation", %{bot: bot, session_id: session_id} do
      first_message = create_message()
      second_message = create_message(sent_at: :os.system_time(:seconds) + 1)

      {:ok, _message} = Conversation.add_message(bot, session_id, first_message)
      {:ok, conversation} = Conversation.get(session_id)

      assert length(conversation.messages) == 1
      assert conversation.session_id == session_id
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == first_message.sent_at

      Conversation.add_message(bot, session_id, second_message)
      {:ok, conversation} = Conversation.get(session_id)

      assert length(conversation.messages) == 2
      assert conversation.session_id == session_id
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == second_message.sent_at
    end
  end

  describe "get/1" do
    test "fails if no conversation exist with that session id", %{session_id: session_id} do
      assert  {:error, _} = Conversation.get(session_id)
    end

    test "retrieves an existing conversation", %{bot: bot, session_id: session_id} do
      message = create_message()
      Conversation.add_message(bot, session_id, message)
      assert {:ok, conversation} = Conversation.get(session_id)
      assert conversation.started_at == message.sent_at
    end
  end

  describe "last_message/1" do
    test "returns last message of the conversation", %{bot: bot, session_id: session_id} do
      message = create_message()
      Conversation.add_message(bot, session_id, message)

      last_message = Conversation.last_message(session_id)
      assert last_message.text == message.text
      assert last_message.sent_at == message.sent_at
    end
  end

  describe "terminate/1" do
    test "fails if no conversation exist with that session id", %{session_id: session_id} do
      assert  {:error, _} = Conversation.terminate(session_id)
    end

    test "terminates an existing conversation", %{bot: bot, session_id: session_id} do
      message = create_message()
      Conversation.add_message(bot, session_id, message)
      assert {:ok, _conversation} = Conversation.get(session_id)

      Conversation.terminate(session_id)
      Process.sleep(10)
      assert {:error, _} = Conversation.get(session_id)
    end
  end

  defp create_message(opts \\ []) do
    defaults = [text: "Hello World",
                sent_at: :os.system_time(:seconds)]
    opts = Keyword.merge(defaults, opts)
    struct(Message, opts)
  end
end
