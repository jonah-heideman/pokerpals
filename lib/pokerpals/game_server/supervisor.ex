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

  def start_game(game_id) do
    ## update game record to "started" here??
    Supervisor.start_child(__MODULE__, [game_id])
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
