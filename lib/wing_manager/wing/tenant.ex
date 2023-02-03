defmodule WingManager.Wing.Tenant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :name, :string
    field :slug, :string

    timestamps()
  end

  def downcase_slug(changeset) do
    update_change(changeset, :slug, &String.downcase/1)
  end

  @doc false
  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:slug, :name])
    |> validate_required([:slug, :name])
    |> downcase_slug()
    |> unique_constraint(:slug)
  end
end
