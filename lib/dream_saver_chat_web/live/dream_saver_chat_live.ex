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
        <svg
          class="animate-spin h-16 w-16 text-gray-500"
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
          </circle>
          <path
            class="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
          >
          </path>
        </svg>
      </div>
    <% else %>
      <main class="flex-grow overflow-hidden bg-gray-50">
        <%= if not @chat_start do %>
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
        <% end %>
        <%= if @chat_start do %>
          <div id="chat" class="chat-container p-4 flex flex-col">
            <%= for message <- Enum.reverse(@messages) do %>
              <div class={"message #{if message.sender == :bot, do: "bot-message", else: "user-message"}"}>
                <%= message.content %>
              </div>
            <% end %>
          </div>
        <% end %>
      </main>

      <footer class="bg-gray-100 border-t border-gray-200 p-4">
        <div class="max-w-3xl mx-auto flex">
          <%!-- <form phx-submit="send_message">
            <input type="text" name="message" value="<%= @new_message %>"
                  placeholder="Type a message..." phx-keyup="update_message"/>
            <button type="submit">Send</button>
          </form>

          phx-click="send_message"
          --%>
          <form phx-submit="send_message" class="flex w-full">
            <input
              type="text"
              id="userInput"
              name="userInput"
              class="flex-grow p-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-2 focus:ring-slate-500 bg-white text-gray-700"
              placeholder="메시지를 입력하세요..."
              disabled={not @chat_start}
              value={@new_message}
            />
            <button
              type="submit"
              class="bg-slate-600 text-white px-4 py-2 rounded-r-md hover:bg-slate-700 focus:outline-none focus:ring-2 focus:ring-slate-500"
              disabled={not @chat_start}
            >
              전송
            </button>
          </form>
        </div>
      </footer>
    <% end %>
    """
  end

  def mount(_params, _session, socket) do
    connected?(socket) && Process.send_after(self(), :load_welcome_message, 1000)

    {:ok,
     assign(socket,
       loading: true,
       welcome_message: nil,
       chat_start: false,
       messages: [],
       new_message: ""
     )}
  end

  def handle_info(:load_welcome_message, socket) do
    welcome_message = WelcomeMessage.get_random()

    {:noreply,
     assign(socket, loading: false, welcome_message: welcome_message, chat_start: false)}
  end

  def handle_event("start_chat", _params, socket) do
    # 여기에 채팅 시작 로직

    new_message = %{sender: :bot, content: "안녕하세요! Dream Saver입니다. 이루고 싶은 저축 목표 금액이 얼마인가요?"}
    updated_messages = [new_message | socket.assigns.messages]

    {:noreply,
     socket
     |> assign(chat_start: true)
     |> assign(messages: updated_messages)}
  end

  def handle_event("send_message", params, socket) do
    # 여기에 메시지 전송 로직
    new_message = %{sender: :user, content: params["userInput"]}

    # updated_messages = socket.assigns.messages ++ [new_message]
    # 첫 번째 리스트의 전체를 복사해야 하므로, 메세지가 많아질수록 성능이 저하될 수 있음.
    updated_messages = [new_message | socket.assigns.messages]
    {:noreply, assign(socket, messages: updated_messages)}
  end

  # def handle_event("add_message", params, socket) do
  #   # 여기에 메시지 추가 로직
  #   IO.inspect(params)
  #   {:noreply, socket}
  # end
end
