defmodule Pokerpals.UserSocket do
  use Phoenix.Socket
  alias Pokerpals.User

  channel "game:*", Pokerpals.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket
  def connect(params, socket) do
    {:ok, assign(socket, :user_id, params["user_id"])}
  end

  def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  # def connect(%{"token" => token}, socket) do
  #   case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
  #     {:ok, user} ->
  #       {:ok, assign(socket, :current_user, user)}
  #     {:error, reason} ->
  #       :error
  #     end
  # end
  #
  # def connect(_, _socket), do: :error
  #
  # def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"
end
