defmodule WingManager.PersonnelFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WingManager.Personnel` context.
  """

  @doc """
  Generate a pilot.
  """
  def pilot_fixture(attrs \\ %{}) do
    {:ok, pilot} =
      attrs
      |> Enum.into(%{
        callsign: "some callsign",
        roles: ["option1", "option2"],
        title: "some title"
      })
      |> WingManager.Personnel.create_pilot()

    pilot
  end
end
