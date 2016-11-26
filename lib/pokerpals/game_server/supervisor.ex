defmodule Pokerpals.GameServer.Supervisor do
  use Supervisor
  alias Pokerpals.{GameWorker}

  def start_link, do: Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    children = [
      worker(GameWorker, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

  def init_game(game_id) do
    ## update game record to "started" here??
    IO.puts "INIT GAME"
    Supervisor.start_child(__MODULE__, [game_id])
    # case Supervisor.start_child(__MODULE__, [game_id]) do
    #   {:error, {:already_started, _pid}} ->
    #     IO.puts "Already started"
    #   true ->
    #     IO.puts "Start game"
    # end
  end

  def current_games do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(&game_data/1)
  end

  def game_data({_,pid,_,_}) do
    pid
    |> GenServer.call(:get_data)
  end

end
