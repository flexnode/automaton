defmodule Automaton.Adapters.ConsoleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  describe "parse/1" do
    test "returns the text as it is and set console as the sender" do
      assert Automaton.Adapters.Console.parse("aloha") == {:ok, "console", "aloha", %{}}
    end
  end

  describe "send/4" do
    test "prints the message in console" do
      assert capture_io(fn ->
        Automaton.Adapters.Console.send("console", "aloha", %{}, [])
      end) == "aloha\n"
    end
  end

end
