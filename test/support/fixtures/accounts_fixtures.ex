defmodule WingManager.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WingManager.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

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
      |> valid_user_attributes()
      |> WingManager.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
