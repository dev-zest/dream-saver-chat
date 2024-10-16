defmodule DreamSaverChat.ProcessUserInput do
  @moduledoc """

  """

  @doc """

  """
  def process_user_input(input, step) do
    res =
    case step do
      0 ->
        goal_amount = String.to_integer(input)
        %{
          goal_amount: goal_amount,
          res_msg: "목표 금액 #{goal_amount}원이군요! 한 달에 얼마씩 저축하실 계획이신가요?",
          step: step + 1
        }
      _ ->
        nil
    end
    res
  end



end
