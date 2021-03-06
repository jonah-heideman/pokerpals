defmodule Pokerpals.GameTest do
  use Pokerpals.ModelCase

  alias Pokerpals.Game

  @valid_attrs %{active: true, ended: true, owner_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
