defmodule Automaton.Adapters.FacebookMessengerTest do
  use ExUnit.Case

  describe "parse/1" do

    test "correctly parse response received on webhook" do
      {:ok, message} = Automaton.Adapters.FacebookMessenger.parse(facebook_messenger_response())

      assert message.text == "Testing"
      assert message.sender == "1230262267102156"
      assert message.sent_at == 1498719451536
    end

  end


  def facebook_messenger_response do
    %{"entry" =>
      [%{"id" => "181529391901584",
         "messaging" =>
            [%{"message" =>
                %{"mid" => "mid.$cAAClGbaIonRjI-lBkFc8qP4lPJPp",
                  "seq" => 47708,
                  "text" => "Testing"
                  },
                "recipient" => %{"id" => "181529391901584"},
                "sender" => %{"id" => "1230262267102156"},
                "timestamp" => 1498719451536
            }],
      "time" => 1498719452828}],
      "object" => "page"
    }
  end

end