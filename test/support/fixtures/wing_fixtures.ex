defmodule WingManager.WingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WingManager.Wing` context.
  """

  @doc """
  Generate a unique tenant slug.
  """
  def unique_tenant_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a tenant.
  """
  def tenant_fixture(attrs \\ %{}) do
    {:ok, tenant} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: unique_tenant_slug()
      })
      |> WingManager.Wing.create_tenant()

    tenant
  end
end
