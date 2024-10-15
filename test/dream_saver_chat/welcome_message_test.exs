defmodule DreamSaverChat.WelcomeMessageTest do
  use ExUnit.Case, async: true
  alias DreamSaverChat.WelcomeMessage

  describe "get_random/0" do
    test "returns a string" do
      assert is_binary(WelcomeMessage.get_random())
    end

    test "returns a message from the predefined list" do
      valid_messages = [
        "당신의 저축 목표를 이루는 여정을 시작해볼까요?",
        "꿈을 향한 첫 걸음, 함께 시작해볼까요?",
        "재정적 자유를 향한 여정, 준비되셨나요?",
        "당신의 미래를 위한 저축, 오늘부터 시작해요!",
        "작은 저축으로 큰 꿈을 이루는 방법, 알아볼까요?"
      ]

      message = WelcomeMessage.get_random()
      assert message in valid_messages
    end

    test "returns different messages over multiple calls" do
      messages = Enum.map(1..100, fn _ -> WelcomeMessage.get_random() end)
      assert length(Enum.uniq(messages)) > 1
    end
  end
end
