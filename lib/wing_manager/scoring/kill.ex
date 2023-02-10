defmodule WingManager.Scoring.Kill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "kills" do
    field :target, :string
    belongs_to :pilot, WingManager.Personnel.Pilot

    timestamps()
  end

  @doc false
  def changeset(kill, attrs) do
    kill
    |> cast(attrs, [:target])
    |> validate_required([:target])
  end
end
