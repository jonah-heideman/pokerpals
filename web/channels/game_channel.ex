defmodule Pokerpals.GameChannel do
  use Phoenix.Channel
  alias Pokerpals.GameServer.Supervisor, as: GameSupervisor
  alias Pokerpals.GameWorker

  def join("game:" <> game_id, %{"username" => username, "user_id" => user_id}, socket) do
    send(self, :after_join)
    case GameWorker.join(game_id, user_id, socket.channel_pid) do
      {:ok, _pid} ->
        {:ok, assign(socket, :game_id, game_id)}
      {:error, reason} ->
        {:error, %{reason: reason}}
    end
    {:ok, assign(socket, :username, username)}
  end

  def handle_info(:after_join, socket) do
    broadcast! socket, "user_joined", %{"username" => socket.assigns.username}
    {:noreply, socket}
  end

  def handle_in("start_game", %{"game_id" => game_id}, socket) do
    GameSupervisor.start_game(game_id)
    {:reply, {:ok, %{game_id: game_id}}, socket}
  end

end
