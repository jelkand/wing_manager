defmodule WingManager.ScoringFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WingManager.Scoring` context.
  """

  @doc """
  Generate a kill.
  """
  def kill_fixture(attrs \\ %{}) do
    {:ok, kill} =
      attrs
      |> Enum.into(%{
        target: "some target"
      })
      |> WingManager.Scoring.create_kill()

    kill
  end
end
