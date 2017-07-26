defmodule Automaton.Conversation.ServerTest do
  use ExUnit.Case
  alias Automaton.Conversation.Server
  alias Automaton.Conversation.Message

  setup do
    session_id = "test"
    message = create_message()
    {:ok, server} = Automaton.Conversation.Server.start_link(session_id, message)
    {:ok, server: server, message: message, session_id: session_id}
  end

  test "add message to the conversation", %{server: server} do
    conversation = Server.get_info(server)
    assert length(conversation.messages) == 1

    message = create_message()
    Server.add_message(server, message)

    conversation = Server.get_info(server)
    assert length(conversation.messages) == 2
  end

  test "get the conversation info", %{server: server, session_id: session_id, message: message} do
    conversation = Server.get_info(server)
    assert length(conversation.messages) == 1
    assert conversation.session_id == session_id
    assert conversation.started_at == message.sent_at
    assert conversation.last_message_at == message.sent_at

    [first_message] = conversation.messages

    second_message = create_message()
    Server.add_message(server, second_message)

    conversation = Server.get_info(server)

    assert length(conversation.messages) == 2
    assert conversation.session_id == session_id
    assert conversation.started_at == first_message.sent_at
    assert conversation.last_message_at == second_message.sent_at
  end

  test "get the last message in the conversation info", %{server: server, message: message} do
    last_message = Server.last_message(server)
    assert last_message.sent_at == message.sent_at

    second_message = create_message()
    Server.add_message(server, second_message)

    last_message = Server.last_message(server)
    assert last_message.sent_at == second_message.sent_at
  end

  test "stop the conversation server", %{server: server} do
    Server.stop(server)
    refute Process.alive?(server)
  end

  defp create_message(opts \\ []) do
    defaults = [text: "Hello World",
                sent_at: System.os_time(:microsecond)]
    opts = Keyword.merge(defaults, opts)
    struct(Message, opts)
  end
end
