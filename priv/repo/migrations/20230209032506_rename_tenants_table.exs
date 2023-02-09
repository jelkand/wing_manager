defmodule WingManager.Repo.Migrations.RenameTenantsTable do
  use Ecto.Migration

  def change do
    drop index(:tenants, [:slug])
    rename table(:tenants), to: table(:wings)
    create unique_index(:wings, :slug)
  end
end
