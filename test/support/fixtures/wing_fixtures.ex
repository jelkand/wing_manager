defmodule WingManager.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WingManager.Organizations` context.
  """

  @doc """
  Generate a unique wing slug.
  """
  def unique_wing_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a wing.
  """
  def wing_fixture(attrs \\ %{}) do
    {:ok, wing} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: unique_wing_slug()
      })
      |> WingManager.Organizations.create_wing()

    wing
  end
end
