defmodule WingManager.Scoring do
  @moduledoc """
  The Scoring context.
  """

  import Ecto.Query, warn: false
  alias WingManager.Repo

  alias WingManager.Scoring.Kill

  @doc """
  Returns the list of kills.

  ## Examples

      iex> list_kills()
      [%Kill{}, ...]

  """
  def list_kills(wing) do
    Repo.all(Kill, prefix: Triplex.to_prefix(wing))
  end

  @doc """
  Returns the list of kills.

  ## Examples

      iex> list_kills()
      [%Kill{}, ...]

  """
  def list_kills_with_pilots(wing) do
    Kill
    |> preload(:pilot)
    |> Repo.all(prefix: Triplex.to_prefix(wing))
  end

  @doc """
  Gets a single kill.

  Raises `Ecto.NoResultsError` if the Kill does not exist.

  ## Examples

      iex> get_kill!(123)
      %Kill{}

      iex> get_kill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_kill!(id, wing), do: Repo.get!(Kill, id, prefix: Triplex.to_prefix(wing))

  @doc """
  Creates a kill.

  ## Examples

      iex> create_kill(%{field: value})
      {:ok, %Kill{}}

      iex> create_kill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_kill(attrs \\ %{}, wing) do
    %Kill{}
    |> Kill.changeset(attrs)
    |> Repo.insert(prefix: Triplex.to_prefix(wing))
  end

  @doc """
  Updates a kill.

  ## Examples

      iex> update_kill(kill, %{field: new_value})
      {:ok, %Kill{}}

      iex> update_kill(kill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_kill(%Kill{} = kill, attrs, wing) do
    kill
    |> Kill.changeset(attrs)
    |> Repo.update(prefix: Triplex.to_prefix(wing))
  end

  @doc """
  Deletes a kill.

  ## Examples

      iex> delete_kill(kill)
      {:ok, %Kill{}}

      iex> delete_kill(kill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_kill(%Kill{} = kill, wing) do
    Repo.delete(kill, prefix: Triplex.to_prefix(wing))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking kill changes.

  ## Examples

      iex> change_kill(kill)
      %Ecto.Changeset{data: %Kill{}}

  """
  def change_kill(%Kill{} = kill, attrs \\ %{}) do
    Kill.changeset(kill, attrs)
  end
end
