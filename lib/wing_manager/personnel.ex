defmodule WingManager.Personnel do
  @moduledoc """
  The Personnel context.
  """

  import Ecto.Query, warn: false
  alias WingManager.Repo

  alias WingManager.Personnel.Pilot

  @doc """
  Returns the list of pilots.

  ## Examples

      iex> list_pilots()
      [%Pilot{}, ...]

  """
  def list_pilots(tenant) do
    Repo.all(Pilot, prefix: Triplex.to_prefix(tenant))
  end

  @doc """
  Gets a single pilot.

  Raises `Ecto.NoResultsError` if the Pilot does not exist.

  ## Examples

      iex> get_pilot!(123)
      %Pilot{}

      iex> get_pilot!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pilot!(id, tenant), do: Repo.get!(Pilot, id, prefix: Triplex.to_prefix(tenant))

  @doc """
  Creates a pilot.

  ## Examples

      iex> create_pilot(%{field: value})
      {:ok, %Pilot{}}

      iex> create_pilot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pilot(attrs \\ %{}, tenant) do
    %Pilot{}
    |> Pilot.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(tenant))
  end

  @doc """
  Updates a pilot.

  ## Examples

      iex> update_pilot(pilot, %{field: new_value})
      {:ok, %Pilot{}}

      iex> update_pilot(pilot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pilot(%Pilot{} = pilot, attrs, tenant) do
    pilot
    |> Pilot.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(tenant))
  end

  @doc """
  Deletes a pilot.

  ## Examples

      iex> delete_pilot(pilot)
      {:ok, %Pilot{}}

      iex> delete_pilot(pilot)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pilot(%Pilot{} = pilot, tenant) do
    Repo.delete(pilot, prefix: Triplex.to_prefix(tenant))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pilot changes.

  ## Examples

      iex> change_pilot(pilot)
      %Ecto.Changeset{data: %Pilot{}}

  """
  def change_pilot(%Pilot{} = pilot, attrs \\ %{}) do
    Pilot.changeset(pilot, attrs)
  end
end
