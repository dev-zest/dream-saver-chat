defmodule DreamSaverChat.ProcessUserInput do
  @moduledoc """

  """

  @doc """

  """
  def process_user_input(input, step, _goal_amount, _monthly_savings) when step == 0 do
    goal_amount = String.to_integer(input)

    %{
      goal_amount: goal_amount,
      res_msg: "목표 금액 #{goal_amount}원이군요! 한 달에 얼마씩 저축하실 계획이신가요?",
      step: step + 1
    }
  end

  def process_user_input(input, step, _goal_amount, _monthly_savings) when step == 1 do
    monthly_savings = String.to_integer(input)

    %{
      monthly_savings: monthly_savings,
      res_msg:
        "매월 #{monthly_savings}원씩 저축하시는군요. 이자는 단리로 계산할까요, 아니면 월 복리로 계산할까요? (단리/월복리로 대답해주세요)",
      step: step + 1
    }
  end

  def process_user_input(input, step, goal_amount, monthly_savings) when step == 2 do
    time_string = '1년'
    %{
      res_msg:
        "목표 금액을 모으는 데 약 #{time_string}이 걸릴 것 같아요.",
      step: 0
    }
  end

  # defp calculate_savings("단리") do
  #   annual_interest_rate = 0.05
  #   #monthly_interest_rate = annual_interest_rate / 12;
  #   months=
  # end
end
