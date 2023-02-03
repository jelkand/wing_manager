defmodule WingManager.Wing.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :name, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:slug, :name])
    |> validate_required([:slug, :name])
    |> unique_constraint(:slug)
  end
end
