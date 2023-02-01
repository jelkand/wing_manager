defmodule WingManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WingManager.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        discord_avatar_hash: "some discord_avatar_hash",
        discord_discriminator: "some discord_discriminator",
        discord_id: "some discord_id",
        discord_username: "some discord_username"
      })
      |> WingManager.Accounts.create_user()

    user
  end
end
