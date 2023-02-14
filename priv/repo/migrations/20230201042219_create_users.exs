defmodule WingManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :discord_id, :string
      add :discord_avatar_hash, :string
      add :discord_username, :string
      add :discord_discriminator, :string

      timestamps()
    end

    create unique_index(:users, [:discord_id])
  end
end
