defmodule WingManager.Repo.Migrations.CreateKills do
  use Ecto.Migration

  def change do
    create table(:kills) do
      add :target, :string
      add :wing_id, :integer, null: false

      add :pilot_id, references(:pilots, with: [wing_id: :wing_id]), null: false

      timestamps()
    end

    create index(:kills, [:pilot_id])
    create index(:kills, [:wing_id])
  end
end
