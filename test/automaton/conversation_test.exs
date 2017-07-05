defmodule Automaton.ConversationTest do
  use ExUnit.Case
  alias Automaton.Conversation
  alias Automaton.Conversation.Message

  @bot __MODULE__
  @sender :test

  setup do
    on_exit fn ->
      Conversation.terminate({@bot, @sender})
    end

    %{bot: @bot}
  end

  describe "add_message/2" do
    test "starts a new conversation if no previous conversation found", %{bot: bot} do
      message = create_message()

      assert {:ok, message} = Conversation.add_message(message, bot)

      {:ok, conversation} = Conversation.get(message.session_id)
      assert length(conversation.messages) == 1
    end
  end

  describe "add_message/3" do
    test "continues the previous conversation", %{bot: bot} do
      first_message = create_message()
      second_message = create_message(sent_at: :os.system_time(:seconds) + 1)

      {:ok, message} = Conversation.add_message(first_message, bot)
      session_id = message.session_id
      {:ok, conversation} = Conversation.get(session_id)

      assert length(conversation.messages) == 1
      assert conversation.session_id == session_id
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == first_message.sent_at

      Conversation.add_message(second_message, bot, session_id)
      {:ok, conversation} = Conversation.get(session_id)

      assert length(conversation.messages) == 2
      assert conversation.session_id == session_id
      assert conversation.started_at == first_message.sent_at
      assert conversation.last_message_at == second_message.sent_at
    end
  end

  describe "get/1" do
    test "fails if no conversation exist with that session id" do
      assert  {:error, _} = Conversation.get("test")
    end

    test "retrieves an existing conversation", %{bot: bot} do
      message = create_message()
      {:ok, message} = Conversation.add_message(message, bot)
      assert {:ok, conversation} = Conversation.get(message.session_id)
      assert conversation.started_at == message.sent_at
      assert conversation.messages == [message]
    end
  end

  describe "last_message/1" do
    test "returns last message of the conversation", %{bot: bot} do
      message = create_message()
      {:ok, message} = Conversation.add_message(message, bot)

      last_message = Conversation.last_message(message.session_id)
      assert last_message == message
    end
  end

  describe "terminate/1" do
    test "fails if no conversation exist with that session id" do
      assert  {:error, _} = Conversation.terminate("test")
    end

    test "terminates an existing conversation", %{bot: bot} do
      message = create_message()
      {:ok, message} = Conversation.add_message(message, bot)
      session_id = message.session_id

      assert {:ok, _conversation} = Conversation.get(session_id)

      Conversation.terminate(session_id)
      Process.sleep(10)
      assert {:error, _} = Conversation.get(session_id)
    end
  end

  defp create_message(opts \\ []) do
    defaults = [text: "Hello World",
                sent_at: :os.system_time(:seconds),
                sender: :test]
    opts = Keyword.merge(defaults, opts)
    struct(Message, opts)
  end
end
