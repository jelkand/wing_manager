defmodule WingManager.Personnel.Pilot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pilots" do
    field :callsign, :string
    field :roles, {:array, :string}
    field :title, :string
    belongs_to :user, WingManager.Accounts.User
    has_many :kills, WingManager.Scoring.Kill

    timestamps()
  end

  @doc false
  def changeset(pilot, attrs) do
    pilot
    |> cast(attrs, [:callsign, :title, :roles])
    |> validate_required([:callsign])
  end
end
