defmodule WingManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :discord_avatar_hash, :string
    field :discord_discriminator, :string
    field :discord_id, :string
    field :discord_username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:discord_id, :discord_avatar_hash, :discord_username, :discord_discriminator])
    |> validate_required([:discord_id, :discord_avatar_hash, :discord_username, :discord_discriminator])
  end
end
