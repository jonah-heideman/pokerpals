require IEx
defmodule Pokerpals.GameChannel do
  use Phoenix.Channel
  alias Pokerpals.GameServer.Supervisor, as: GameSupervisor
  alias Pokerpals.GameWorker

  def join("game:" <> game_id, %{"username" => username, "user_id" => user_id}, socket) do
    send(self, :after_join)

    game_pid = case GameSupervisor.init_game(game_id) do
      {:ok, pid} ->
        IO.puts "should initialize game"
        pid
      {:error, {:already_started, pid}} ->
        IO.puts "game already initialized"
        pid
    end
    join = GameWorker.join(game_id, user_id, game_pid)
    IO.puts "Join game: #{inspect(join)}"
    case join do
      {:ok, _pid} ->
        socket = assign(socket, :game_id, game_id)
        socket = assign(socket, :game_pid, game_pid)
      {:error, reason} ->
        IO.puts "Error joining game: #{reason}"
    end
    {:ok, assign(socket, :username, username)}
  end

  def handle_info(:after_join, socket) do
    IO.puts "socket.assigns: #{inspect(socket.assigns)}"
    broadcast! socket, "user_joined", %{"username" => socket.assigns.username}
    {:noreply, socket}
  end

  def handle_in("start_game", %{"game_id" => game_id, "user_id" => user_id}, %{:assigns => %{:game_pid => game_pid}} = socket) do
    resp = GameWorker.begin_game(game_id, user_id, game_pid)
    case resp do
      {:ok, _} ->
        broadcast! socket, "game_started", %{"game_id" => game_id}
      {:error, error} ->
        IO.puts "Error in start_game: #{error}"
    end
    {:noreply, socket}
  end

end
