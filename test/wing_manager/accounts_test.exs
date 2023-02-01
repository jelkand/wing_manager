defmodule WingManager.AccountsTest do
  use WingManager.DataCase

  alias WingManager.Accounts

  describe "users" do
    alias WingManager.Accounts.User

    import WingManager.AccountsFixtures

    @invalid_attrs %{discord_avatar_hash: nil, discord_discriminator: nil, discord_id: nil, discord_username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{discord_avatar_hash: "some discord_avatar_hash", discord_discriminator: "some discord_discriminator", discord_id: "some discord_id", discord_username: "some discord_username"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.discord_avatar_hash == "some discord_avatar_hash"
      assert user.discord_discriminator == "some discord_discriminator"
      assert user.discord_id == "some discord_id"
      assert user.discord_username == "some discord_username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{discord_avatar_hash: "some updated discord_avatar_hash", discord_discriminator: "some updated discord_discriminator", discord_id: "some updated discord_id", discord_username: "some updated discord_username"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.discord_avatar_hash == "some updated discord_avatar_hash"
      assert user.discord_discriminator == "some updated discord_discriminator"
      assert user.discord_id == "some updated discord_id"
      assert user.discord_username == "some updated discord_username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
