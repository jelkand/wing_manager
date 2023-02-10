defmodule WingManager.Repo.Migrations.CreateKills do
  use Ecto.Migration

  def change do
    create table(:kills) do
      add :target, :string
      add :pilot_id, references(:pilots, on_delete: :nothing)

      timestamps()
    end

    create index(:kills, [:pilot_id])
  end
end
