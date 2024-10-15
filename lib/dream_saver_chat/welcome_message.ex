defmodule DreamSaverChat.WelcomeMessage do
  @moduledoc """
  Manages welcome messages for the DreamSaverChat application.
  This module provides various motivational messages to display to users.
  """

  @welcome_messages [
    "당신의 저축 목표를 이루는 여정을 시작해볼까요?",
    "꿈을 향한 첫 걸음, 함께 시작해볼까요?",
    "재정적 자유를 향한 여정, 준비되셨나요?",
    "당신의 미래를 위한 저축, 오늘부터 시작해요!",
    "작은 저축으로 큰 꿈을 이루는 방법, 알아볼까요?"
  ]

  @doc """
  Returns a random welcome message from the list.

  ## Example

      iex> DreamSaverChat.WelcomeMessage.get_random()
      "당신의 저축 목표를 이루는 여정을 시작해볼까요?"

  Note that the returned message may vary with each call.
  """
  def get_random do
    Enum.random(@welcome_messages)
  end
end
