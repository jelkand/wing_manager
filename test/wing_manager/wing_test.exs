defmodule WingManager.OrganizationsTest do
  use WingManager.DataCase

  alias WingManager.Organizations

  describe "wings" do
    alias WingManager.Organizations.Wing

    import WingManager.OrganizationsFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_wings/0 returns all wings" do
      wing = wing_fixture()
      assert Organizations.list_wings() == [wing]
    end

    test "get_wing!/1 returns the wing with given id" do
      wing = wing_fixture()
      assert Organizations.get_wing!(wing.id) == wing
    end

    test "create_wing/1 with valid data creates a wing" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Wing{} = wing} = Organizations.create_wing(valid_attrs)
      assert wing.name == "some name"
      assert wing.slug == "some slug"
    end

    test "create_wing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_wing(@invalid_attrs)
    end

    test "update_wing/2 with valid data updates the wing" do
      wing = wing_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Wing{} = wing} = Organizations.update_wing(wing, update_attrs)
      assert wing.name == "some updated name"
      assert wing.slug == "some updated slug"
    end

    test "update_wing/2 with invalid data returns error changeset" do
      wing = wing_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_wing(wing, @invalid_attrs)
      assert wing == Organizations.get_wing!(wing.id)
    end

    test "delete_wing/1 deletes the wing" do
      wing = wing_fixture()
      assert {:ok, %Wing{}} = Organizations.delete_wing(wing)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_wing!(wing.id) end
    end

    test "change_wing/1 returns a wing changeset" do
      wing = wing_fixture()
      assert %Ecto.Changeset{} = Organizations.change_wing(wing)
    end
  end
end
