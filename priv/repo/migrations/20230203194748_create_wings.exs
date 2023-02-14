defmodule WingManager.Repo.Migrations.CreateWings do
  use Ecto.Migration

  def change do
    create table(:wings) do
      add :slug, :string, null: false
      add :name, :string, null: false
      add :avatar, :string

      timestamps()
    end

    create unique_index(:wings, [:slug])
  end
end
