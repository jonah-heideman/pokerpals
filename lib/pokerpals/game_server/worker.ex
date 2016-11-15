defmodule Pokerpals.GameWorker do
  use GenServer

  defstruct [
    id: nil,
    players: nil,
    over: false,
    winnder: nil,
    full: false
  ]

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, name: ref(id))
  end

  def init(id) do
    {:ok, %__MODULE__{id: id}}
  end

  def join(id, user_id, pid), do: try_call(id, {:join, user_id, pid})

  def handle_call({:join, user_id, pid}, _from, game) do
    cond do
      game.full ->
        {:reply, {:error, "No more players allowed"}, game}
      Enum.member?(game.players, user_id) ->
        {:reply, {:ok, self}, game}
      true ->
        Process.flag(:trap_exit, true)
        Process.monitor(pid)

        game = add_user(game, user_id)

        {:reply, {:ok, self}, game}
    end
  end

  defp add_user(game, user_id) do
    IO.puts("ADD USER: #{user_id}")
  end

  defp ref(id), do: {:global, {:game, id}}

  defp try_call(id, message) do
    case GenServer.whereis(ref(id)) do
      nil ->
        {:error, "Game does not exist"}
      pid ->
        GenServer.call(pid, message)
    end
  end
end
