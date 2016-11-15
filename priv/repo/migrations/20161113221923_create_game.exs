defmodule Pokerpals.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :owner_id, references(:users, on_delete: :nothing)
      add :active, :boolean, default: false, null: false
      add :ended, :boolean, default: false, null: false

      timestamps()
    end
    create index(:games, [:owner_id])

  end
end
