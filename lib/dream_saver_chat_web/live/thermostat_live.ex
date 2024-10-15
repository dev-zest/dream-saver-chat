defmodule DreamSaverChatWeb.ThermostatLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <%!-- Current temperature: <%= @temperature %>°F
    <button phx-click="inc_temperature">+</button> --%>
    <header class="bg-white border-b p-4 flex justify-center items-center">
      <h1 class="text-3xl font-bold text-green-600">Dream Saver</h1>
    </header>

    <main class="flex-grow overflow-hidden">
      <div id="start-screen" class="center-content p-4">
        <h2 id="welcome-message" class="text-2xl font-bold mb-4"></h2>
        <button
          onclick="startChat()"
          class="bg-green-500 text-white px-6 py-3 rounded-md hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-green-400"
        >
          목표 설정하기
        </button>
      </div>
      <div id="chat" class="chat-container p-4 flex flex-col hidden"></div>
    </main>

    <footer class="bg-white border-t p-4">
      <div class="max-w-3xl mx-auto flex">
        <input
          type="text"
          id="userInput"
          class="flex-grow p-2 border rounded-l-md focus:outline-none focus:ring-2 focus:ring-green-400"
          placeholder="메시지를 입력하세요..."
          disabled
        />
        <button
          onclick="sendMessage()"
          class="bg-green-500 text-white px-4 py-2 rounded-r-md hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-green-400"
          disabled
        >
          전송
        </button>
      </div>
    </footer>
    """
  end

  def mount(_params, _session, socket) do
    # Let's assume a fixed temperature for now
    temperature = 70
    {:ok, assign(socket, :temperature, temperature)}
  end

  def handle_event("inc_temperature", _params, socket) do
    {:noreply, update(socket, :temperature, &(&1 + 1))}
  end
end
