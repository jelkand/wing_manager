defmodule WingManager.Repo.Migrations.CreatePilots do
  use Ecto.Migration

  def change do
    create table(:pilots) do
      add :callsign, :string
      add :title, :string
      add :roles, {:array, :string}
      add :user_id, references(:users, on_delete: :nothing, prefix: :public)

      timestamps()
    end

    create index(:pilots, [:user_id])
  end
end
