defmodule WingManager.PersonnelTest do
  use WingManager.DataCase

  alias WingManager.Personnel

  describe "pilots" do
    alias WingManager.Personnel.Pilot

    import WingManager.PersonnelFixtures

    @invalid_attrs %{callsign: nil, roles: nil, title: nil}

    test "list_pilots/0 returns all pilots" do
      pilot = pilot_fixture()
      assert Personnel.list_pilots() == [pilot]
    end

    test "get_pilot!/1 returns the pilot with given id" do
      pilot = pilot_fixture()
      assert Personnel.get_pilot!(pilot.id) == pilot
    end

    test "create_pilot/1 with valid data creates a pilot" do
      valid_attrs = %{
        callsign: "some callsign",
        roles: ["option1", "option2"],
        title: "some title"
      }

      assert {:ok, %Pilot{} = pilot} = Personnel.create_pilot(valid_attrs)
      assert pilot.callsign == "some callsign"
      assert pilot.roles == ["option1", "option2"]
      assert pilot.title == "some title"
    end

    test "create_pilot/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Personnel.create_pilot(@invalid_attrs)
    end

    test "update_pilot/2 with valid data updates the pilot" do
      pilot = pilot_fixture()

      update_attrs = %{
        callsign: "some updated callsign",
        roles: ["option1"],
        title: "some updated title"
      }

      assert {:ok, %Pilot{} = pilot} = Personnel.update_pilot(pilot, update_attrs)
      assert pilot.callsign == "some updated callsign"
      assert pilot.roles == ["option1"]
      assert pilot.title == "some updated title"
    end

    test "update_pilot/2 with invalid data returns error changeset" do
      pilot = pilot_fixture()
      assert {:error, %Ecto.Changeset{}} = Personnel.update_pilot(pilot, @invalid_attrs)
      assert pilot == Personnel.get_pilot!(pilot.id)
    end

    test "delete_pilot/1 deletes the pilot" do
      pilot = pilot_fixture()
      assert {:ok, %Pilot{}} = Personnel.delete_pilot(pilot)
      assert_raise Ecto.NoResultsError, fn -> Personnel.get_pilot!(pilot.id) end
    end

    test "change_pilot/1 returns a pilot changeset" do
      pilot = pilot_fixture()
      assert %Ecto.Changeset{} = Personnel.change_pilot(pilot)
    end
  end
end
