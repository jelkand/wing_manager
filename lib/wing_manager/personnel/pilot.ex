defmodule WingManager.Personnel.Pilot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pilots" do
    field :callsign, :string
    field :roles, {:array, :string}
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(pilot, attrs) do
    pilot
    |> cast(attrs, [:callsign, :title, :roles])
    |> validate_required([:callsign, :title, :roles])
  end
end
