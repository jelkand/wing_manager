defmodule WingManager.Repo.Migrations.CreatePilots do
  use Ecto.Migration

  def change do
    create table(:pilots) do
      add :callsign, :string
      add :title, :string
      add :roles, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :wing_id, references(:wings, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:pilots, [:user_id])
    create index(:pilots, [:wing_id])

    create unique_index(:pilots, [:id, :wing_id])
  end
end
