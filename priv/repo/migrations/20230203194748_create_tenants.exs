defmodule WingManager.Repo.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    create table(:tenants) do
      add :slug, :string
      add :name, :string

      timestamps()
    end

    create unique_index(:tenants, [:slug])
  end
end
