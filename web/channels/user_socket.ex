defmodule Pokerpals.UserSocket do
  use Phoenix.Socket
  alias Pokerpals.User

  channel "game:*", Pokerpals.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(%{"id" => user_id}, socket) do
    {:ok, assign(socket, :user_id, user_id)}
  end

  def connect(_, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
end
