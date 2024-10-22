defmodule DreamSaverChat.ProcessUserInput do
  @moduledoc """
  사용자의 저축 목표와 계획을 처리하고 목표 달성 시기를 계산하는 모듈입니다.
  단계별로 사용자의 입력을 받아 목표 금액, 월 저축액, 이자 계산 방식을 설정하고
  최종적으로 목표 금액 달성에 필요한 예상 기간을 계산합니다.
  """

  @doc """
  사용자의 입력을 처리하고 다음 단계의 메시지를 생성합니다.

  ## 매개변수
    - input: 사용자 입력값
    - step: 현재 진행 단계 (0: 목표금액, 1: 월저축액, 2: 이자계산방식)
    - goal_amount: 목표 금액
    - monthly_savings: 월 저축액

  ## 반환값
    %{
      goal_amount: integer() | nil,
      monthly_savings: integer() | nil,
      res_msg: String.t(),
      step: integer()
    }
  """
  def process_user_input(input, step, _goal_amount, _monthly_savings) when step == 0 do
    goal_amount = String.to_integer(input)

    %{
      goal_amount: goal_amount,
      res_msg: "목표 금액 #{goal_amount}원이군요! 한 달에 얼마씩 저축하실 계획이신가요?",
      step: step + 1
    }
  end

  @doc """
  월 저축액을 설정하고 이자 계산 방식 선택 단계로 진행합니다.
  """
  def process_user_input(input, step, _goal_amount, _monthly_savings) when step == 1 do
    monthly_savings = String.to_integer(input)

    %{
      monthly_savings: monthly_savings,
      res_msg:
        "매월 #{monthly_savings}원씩 저축하시는군요. 이자는 단리로 계산할까요, 아니면 월 복리로 계산할까요? (단리/월복리로 대답해주세요)",
      step: step + 1
    }
  end

  @doc """
  선택된 이자 계산 방식에 따라 목표 금액 달성 기간을 계산하고 결과를 반환합니다.
  """
  def process_user_input(input, step, goal_amount, monthly_savings) when step == 2 do
    {:ok, time_string} = calculate_savings(input, goal_amount, monthly_savings)
    %{
      res_msg:
        "목표 금액을 모으는 데 약 #{time_string}이 걸릴 것 같아요.",
      step: 0
    }
  end

  @doc """
  단리 방식으로 목표 금액 달성 기간을 계산합니다.

  ## 매개변수
    - goal_amount: 목표 금액
    - monthly_savings: 월 저축액

  ## 반환값
    {:ok, String.t()} - 계산된 기간을 문자열로 반환
  """
  defp calculate_savings("단리", goal_amount, monthly_savings) do
    annual_interest_rate = 0.05  # 연 5% 이자율

    months = Float.ceil(goal_amount / (monthly_savings + (monthly_savings * annual_interest_rate / 12)))
    years = trunc(Float.floor(months / 12))
    remaining_months = rem(trunc(months), 12)

    result = cond do
      years > 0 -> "#{years}년"
      remaining_months > 0 -> "#{remaining_months}개월"
      true -> "기간 없음"
    end

    {:ok, result}
  end

  @doc """
  월복리 방식으로 목표 금액 달성 기간을 계산합니다.

  ## 매개변수
    - goal_amount: 목표 금액
    - monthly_savings: 월 저축액

  ## 반환값
    {:ok, String.t()} - 계산된 기간을 문자열로 반환
  """
  defp calculate_savings("월복리", goal_amount, monthly_savings) do
    annual_interest_rate = 0.05  # 연 5% 이자율
    monthly_interest_rate = annual_interest_rate / 12

    months = Float.ceil(Math.log(goal_amount * monthly_interest_rate / monthly_savings + 1) / Math.log(1 + monthly_interest_rate))
    years = trunc(Float.floor(months / 12))
    remaining_months = rem(trunc(months), 12)

    result = cond do
      years > 0 -> "#{years}년"
      remaining_months > 0 -> "#{remaining_months}개월"
      true -> "기간 없음"
    end

    {:ok, result}
  end
end
