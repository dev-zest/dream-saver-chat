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
      1 ->
        monthly_savings = String.to_integer(input)
        %{
          monthly_savings: monthly_savings,
          res_msg: "매월 #{monthly_savings}원씩 저축하시는군요. 이자는 단리로 계산할까요, 아니면 월 복리로 계산할까요? (단리/월복리로 대답해주세요)",
          step: step + 1
        }
      _ ->
        nil
    end
    res
  end



end
