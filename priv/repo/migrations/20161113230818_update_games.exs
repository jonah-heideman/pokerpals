defmodule Pokerpals.Repo.Migrations.UpdateGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      remove :owner_id
      add :user_id, references(:users, on_delete: :nothing)
    end
    create index(:games, [:user_id])
  end
end
