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
  def list_kills do
    Repo.all(Kill)
  end

  @doc """
  Returns the list of kills.

  ## Examples

      iex> list_kills()
      [%Kill{}, ...]

  """
  def list_kills_with_pilots do
    Kill
    |> preload(:pilot)
    |> Repo.all()
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
  def get_kill!(id), do: Repo.get!(Kill, id)

  @doc """
  Creates a kill.

  ## Examples

      iex> create_kill(%{field: value})
      {:ok, %Kill{}}

      iex> create_kill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_kill(attrs \\ %{}) do
    %Kill{}
    |> Kill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a kill.

  ## Examples

      iex> update_kill(kill, %{field: new_value})
      {:ok, %Kill{}}

      iex> update_kill(kill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_kill(%Kill{} = kill, attrs) do
    kill
    |> Kill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a kill.

  ## Examples

      iex> delete_kill(kill)
      {:ok, %Kill{}}

      iex> delete_kill(kill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_kill(%Kill{} = kill) do
    Repo.delete(kill)
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
