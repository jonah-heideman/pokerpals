defmodule Pokerpals.Game do
  use Pokerpals.Web, :model

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
end
