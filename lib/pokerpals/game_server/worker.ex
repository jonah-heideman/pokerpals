require IEx
defmodule Pokerpals.GameWorker do
  use GenServer
  alias Pokerpals.Repo
  alias Pokerpals.Game

  @min_players 2
  @max_players 3

  defstruct [
    id: nil,
    active: false,
    ready: false,
    full: false,
    player_ids: []
  ]

  def start_link(id) do
    IO.puts "START LINK: #{id}"
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  def init(id) do
    IO.puts "INIT: #{id}"
    {:ok, %__MODULE__{id: id}}
  end

  def join(id, user_id, pid), do: try_call(id, {:join, user_id, pid})
  def begin_game(id, user_id, pid), do: try_call(id, {:begin_game, user_id, pid})

  def handle_call({:begin_game, user_id, pid}, _from, %{:ready => ready, :id => id} = game) when ready == false do
    IO.puts "game id:#{id} not ready, cannot begin"
    {:reply, {:ok, self}, game}
  end

  def handle_call({:begin_game, user_id, pid}, _from, %{:ready => ready, :id => id} = game) do
    update = case update_game_started(game) do
      {:ok, record} ->
        IO.puts "game id:#{id} has begun!"
        record
      {:error, game} ->
        IO.puts "could not begin game id:#{id}"
        game
    end
    {:reply, {:ok, self}, update}
  end

  def handle_call({:join, user_id, pid}, _from, game) do
    # cond do
    #   game.full ->
    #     {:reply, {:error, "No more players allowed"}, game}
    #   Enum.member?(game.players, user_id) ->
    #     {:reply, {:ok, self}, game}
    #   true ->
        Process.flag(:trap_exit, true)
        Process.monitor(pid)

        game = add_user(game, user_id)
          |> set_ready_state
          |> set_full_state

        IO.puts "Game state: #{inspect(game)}"
        {:reply, {:ok, self}, game}
    # end
  end

  defp update_game_started(game) do
    Game.start_game(game)
  end

  defp set_ready_state(%{:player_ids => player_ids} = game) when length(player_ids) < @min_players, do: game
  defp set_ready_state(game) do
    %{game | ready: true}
  end

  defp set_full_state(%{:player_ids => player_ids, :full => full} = game) when length(player_ids) == @max_players and full == false do
    %{game | full: true}
  end
  defp set_full_state(game), do: game

  defp add_user(%{:full => full, :id => id} = game, user_id) when full do
    IO.puts "game id:#{id} is full, user id:#{user_id} did not join"
    game
  end

  defp add_user(%{:player_ids => player_ids} = game, user_id) do
    %{game | player_ids: player_ids ++ [user_id]}
  end

  def ref(id), do: {:global, {:game_id, id}}

  defp try_call(id, message) do
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exist"}
      pid ->
        GenServer.call(pid, message)
    end
  end
end
