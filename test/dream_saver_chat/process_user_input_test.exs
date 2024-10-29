defmodule DreamSaverChat.ProcessUserInputTest do
  use ExUnit.Case
  doctest DreamSaverChat.ProcessUserInput

  alias DreamSaverChat.ProcessUserInput

  describe "process_user_input/4 for step 0 (goal amount)" do
    test "processes valid goal amount input" do
      result = ProcessUserInput.process_user_input("1000000", 0, nil, nil)

      assert result.goal_amount == 1_000_000
      assert result.step == 1
      assert result.res_msg == "목표 금액 1000000원이군요! 한 달에 얼마씩 저축하실 계획이신가요?"
    end

    test "raises error for invalid goal amount input" do
      assert_raise ArgumentError, fn ->
        ProcessUserInput.process_user_input("invalid", 0, nil, nil)
      end
    end
  end

  describe "process_user_input/4 for step 1 (monthly savings)" do
    test "processes valid monthly savings input" do
      result = ProcessUserInput.process_user_input("50000", 1, 1_000_000, nil)

      assert result.monthly_savings == 50_000
      assert result.step == 2
      assert result.res_msg == "매월 50000원씩 저축하시는군요. 이자는 단리로 계산할까요, 아니면 월 복리로 계산할까요? (단리/월복리로 대답해주세요)"
    end

    test "raises error for invalid monthly savings input" do
      assert_raise ArgumentError, fn ->
        ProcessUserInput.process_user_input("invalid", 1, 1_000_000, nil)
      end
    end
  end

  describe "process_user_input/4 for step 2 (interest calculation)" do
    test "calculates simple interest period correctly" do
      result = ProcessUserInput.process_user_input("단리", 2, 1_000_000, 50_000)

      assert result.step == 0
      assert String.contains?(result.res_msg, "목표 금액을 모으는 데 약")
      assert String.contains?(result.res_msg, "이 걸릴 것 같아요.")
    end

    test "calculates compound interest period correctly" do
      result = ProcessUserInput.process_user_input("월복리", 2, 1_000_000, 50_000)

      assert result.step == 0
      assert String.contains?(result.res_msg, "목표 금액을 모으는 데 약")
      assert String.contains?(result.res_msg, "이 걸릴 것 같아요.")
    end

    test "handles edge case with very small goal amount" do
      result = ProcessUserInput.process_user_input("단리", 2, 100, 1000)

      assert result.step == 0
      assert String.contains?(result.res_msg, "목표 금액을 모으는 데 약")
    end

    test "handles edge case with very large goal amount" do
      result = ProcessUserInput.process_user_input("월복리", 2, 100_000_000, 1000)

      assert result.step == 0
      assert String.contains?(result.res_msg, "목표 금액을 모으는 데 약")
    end
  end

  describe "error cases" do
    test "handles invalid interest type" do
      assert_raise FunctionClauseError, fn ->
        ProcessUserInput.process_user_input("잘못된입력", 2, 1_000_000, 50_000)
      end
    end

    test "handles invalid step number" do
      assert_raise FunctionClauseError, fn ->
        ProcessUserInput.process_user_input("1000000", 3, nil, nil)
      end
    end
  end
end
