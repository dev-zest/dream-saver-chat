defmodule DreamSaverChatWeb.DreamSaverChatLiveTest do
  use DreamSaverChatWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "초기 로딩" do
    test "마운트시 로딩 상태 표시", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      assert render(view) =~ "animate-spin"
    end

    test "환영 메시지 표시", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      # 로딩이 끝나고 환영 메시지가 표시되기를 기다립니다
      :timer.sleep(1100)
      html = render(view)

      assert html =~ "Dream Saver"
      assert html =~ "목표 설정하기"
      refute html =~ "animate-spin"
    end
  end

  describe "채팅 기능" do
    test "채팅 시작 버튼 클릭", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)  # 로딩 대기

      html = render_click(view, "start_chat")
      assert html =~ "안녕하세요! Dream Saver입니다"
      assert html =~ "이루고 싶은 저축 목표 금액이 얼마인가요?"
    end

    test "목표 금액 입력 처리", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)
      render_click(view, "start_chat")

      html = render_submit(view, "send_message", %{"userInput" => "1000000"})
      assert html =~ "목표 금액 1000000원이군요"
      assert html =~ "한 달에 얼마씩 저축하실 계획이신가요?"
    end

    test "월 저축액 입력 처리", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)
      render_click(view, "start_chat")
      render_submit(view, "send_message", %{"userInput" => "1000000"})

      html = render_submit(view, "send_message", %{"userInput" => "50000"})
      assert html =~ "매월 50000원씩 저축하시는군요"
      assert html =~ "이자는 단리로 계산할까요, 아니면 월 복리로 계산할까요?"
    end

    test "이자 계산 방식 입력 처리", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)
      render_click(view, "start_chat")
      render_submit(view, "send_message", %{"userInput" => "1000000"})
      render_submit(view, "send_message", %{"userInput" => "50000"})

      html = render_submit(view, "send_message", %{"userInput" => "단리"})
      assert html =~ "목표 금액을 모으는 데 약"
      assert html =~ "이 걸릴 것 같아요"
    end
  end

  describe "UI 요소" do
    test "필수 UI 컴포넌트 존재 확인", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)
      html = render(view)

      assert html =~ ~s(class="text-3xl font-bold text-gray-700")  # 제목 스타일
      assert html =~ "목표 설정하기"  # 시작 버튼
      assert html =~ ~s(placeholder="메시지를 입력하세요...")  # 입력창
      assert html =~ "전송"  # 전송 버튼
    end

    test "채팅창 비활성화 상태 확인", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)
      html = render(view)

      assert html =~ ~s(disabled)  # 채팅 시작 전 입력창 비활성화 상태
    end

    test "채팅창 활성화 상태 확인", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      :timer.sleep(1100)
      html = render_click(view, "start_chat")

      refute html =~ ~s(type="text" disabled)  # 채팅 시작 후 입력창 활성화 상태
    end
  end
end
