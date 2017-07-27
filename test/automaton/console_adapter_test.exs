defmodule Automaton.Console.AdapterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "parse/1" do
    test "returns the text as it is and set console as the sender" do
      assert Automaton.Console.Adapter.parse("aloha") == {:ok, "console", "aloha", %{}}
    end
  end

  describe "send/4" do
    test "prints the message in console" do
      assert capture_io(fn ->
        Automaton.Console.Adapter.send("console", "aloha", %{}, [])
      end) == "aloha\n"
    end
  end

end
