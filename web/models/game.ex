defmodule Pokerpals.Game do
  use Pokerpals.Web, :model
  alias Pokerpals.Repo
  alias Pokerpals.Game

  schema "games" do
    field :active, :boolean, default: false
    field :ended, :boolean, default: false
    belongs_to :user, Pokerpals.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:active, :ended])
  end

  def start_game(%{:id => game_id} = game) do
    game_record = Repo.get(Game, game_id)
    changeset = Ecto.Changeset.change game_record, active: true
    msg = case Repo.update(changeset) do
      {:ok, record} ->
        IO.puts "Game id:#{game_id} started"
        {:ok, record}
      {:error, changeset} ->
        IO.puts "Error starting game id:#{game_id}"
        {:error, game}
    end
    msg
  end
  
end
