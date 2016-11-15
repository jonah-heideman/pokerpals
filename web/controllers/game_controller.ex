defmodule Pokerpals.GameController do
  use Pokerpals.Web, :controller

  alias Pokerpals.Game

  plug :authenticate_user when action in [:create, :new, :delete]
  plug :can_edit_or_delete? when action in [:delete]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def index(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:games)
      |> Game.changeset()

    games = Repo.all(Game)
    render(conn, "index.html", games: games, changeset: changeset)
  end

  def new(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:games)
      |> Game.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, _params, user) do
    changeset =
      user
      |> build_assoc(:games)
      |> Game.changeset()

    case Repo.insert(changeset) do
      {:ok, _game} ->
        conn
        |> redirect(to: game_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _user) do
    game = Repo.get!(Game, id)
    render(conn, "show.html", game: game)
  end

  def edit(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)
    changeset = Game.changeset(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = Repo.get!(Game, id)
    changeset = Game.changeset(game, game_params)

    case Repo.update(changeset) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: game_path(conn, :show, game))
      {:error, changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = Repo.get!(Game, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: game_path(conn, :index))
  end

  defp can_edit_or_delete?(conn, _opts) do
    %{"id" => id} = conn.params
     {id, _} = Integer.parse(id)
     game = Repo.get_by(Game, id: id)

     if game.user_id == id do
       conn
     else
       redirect(conn, to: game_path(conn, :index))
     end
  end
end
