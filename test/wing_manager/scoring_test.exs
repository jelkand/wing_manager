defmodule WingManager.ScoringTest do
  use WingManager.DataCase

  alias WingManager.Scoring

  describe "kills" do
    alias WingManager.Scoring.Kill

    import WingManager.ScoringFixtures

    @invalid_attrs %{target: nil}

    test "list_kills/0 returns all kills" do
      kill = kill_fixture()
      assert Scoring.list_kills() == [kill]
    end

    test "get_kill!/1 returns the kill with given id" do
      kill = kill_fixture()
      assert Scoring.get_kill!(kill.id) == kill
    end

    test "create_kill/1 with valid data creates a kill" do
      valid_attrs = %{target: "some target"}

      assert {:ok, %Kill{} = kill} = Scoring.create_kill(valid_attrs)
      assert kill.target == "some target"
    end

    test "create_kill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scoring.create_kill(@invalid_attrs)
    end

    test "update_kill/2 with valid data updates the kill" do
      kill = kill_fixture()
      update_attrs = %{target: "some updated target"}

      assert {:ok, %Kill{} = kill} = Scoring.update_kill(kill, update_attrs)
      assert kill.target == "some updated target"
    end

    test "update_kill/2 with invalid data returns error changeset" do
      kill = kill_fixture()
      assert {:error, %Ecto.Changeset{}} = Scoring.update_kill(kill, @invalid_attrs)
      assert kill == Scoring.get_kill!(kill.id)
    end

    test "delete_kill/1 deletes the kill" do
      kill = kill_fixture()
      assert {:ok, %Kill{}} = Scoring.delete_kill(kill)
      assert_raise Ecto.NoResultsError, fn -> Scoring.get_kill!(kill.id) end
    end

    test "change_kill/1 returns a kill changeset" do
      kill = kill_fixture()
      assert %Ecto.Changeset{} = Scoring.change_kill(kill)
    end
  end
end
