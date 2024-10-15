defmodule DreamSaverChatWeb.DreamSaverChatLive do
  use Phoenix.LiveView
  alias DreamSaverChat.WelcomeMessage

  def render(assigns) do
    ~H"""
    <header class="bg-gray-100 border-b border-gray-200 p-4 flex justify-center items-center">
      <h1 class="text-3xl font-bold text-gray-700">Dream Saver</h1>
    </header>

    <%= if @loading do %>
      <div class="flex items-center justify-center h-screen bg-gray-50">
        <svg class="animate-spin h-16 w-16 text-gray-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
      </div>
    <% else %>
      <main class="flex-grow overflow-hidden bg-gray-50">
        <div id="start-screen" class="center-content p-4">
          <h2 id="welcome-message" class="text-2xl font-bold mb-4 min-w-32 text-gray-700">
            <%= @welcome_message %>
          </h2>
          <button
            phx-click="start_chat"
            class="bg-slate-600 text-white px-6 py-3 rounded-md hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-slate-500"
          >
            목표 설정하기
          </button>
        </div>
        <div id="chat" class="chat-container p-4 flex flex-col hidden"></div>
      </main>

      <footer class="bg-gray-100 border-t border-gray-200 p-4">
        <div class="max-w-3xl mx-auto flex">
          <input
            type="text"
            id="userInput"
            class="flex-grow p-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-slate-500 bg-white text-gray-700"
            placeholder="메시지를 입력하세요..."
            disabled
          />
          <button
            phx-click="send_message"
            class="bg-slate-600 text-white px-4 py-2 rounded-r-md hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-slate-500"
            disabled
          >
            전송
          </button>
        </div>
      </footer>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :load_welcome_message, 1000)
      {:ok, assign(socket, loading: true, welcome_message: nil)}
    else
      {:ok, assign(socket, loading: true, welcome_message: nil)}
    end
  end

  def handle_info(:load_welcome_message, socket) do
    welcome_message = WelcomeMessage.get_random()
    {:noreply, assign(socket, loading: false, welcome_message: welcome_message)}
  end

  def handle_event("start_chat", _params, socket) do
    # 여기에 채팅 시작 로직을 추가할 수 있습니다.
    {:noreply, socket}
  end

  def handle_event("send_message", _params, socket) do
    # 여기에 메시지 전송 로직을 추가할 수 있습니다.
    {:noreply, socket}
  end
end
