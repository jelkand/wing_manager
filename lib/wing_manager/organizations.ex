defmodule WingManager.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias WingManager.Repo

  alias WingManager.Organizations.Wing

  @doc """
  Returns the list of wings.

  ## Examples

      iex> list_wings()
      [%Wing{}, ...]

  """
  def list_wings do
    Repo.all(Wing, skip_wing_slug: true)
  end

  @doc """
  Gets a single wing.

  Raises `Ecto.NoResultsError` if the Wing does not exist.

  ## Examples

      iex> get_wing!(123)
      %Wing{}

      iex> get_wing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wing!(id), do: Repo.get!(Wing, id, skip_wing_slug: true)

  def get_wing_by_slug(nil), do: nil

  def get_wing_by_slug(slug),
    do: Repo.get_by(Wing, slug: String.downcase(slug), skip_wing_slug: true)

  @doc """
  Creates a wing.

  ## Examples

      iex> create_wing(%{field: value})
      {:ok, %Wing{}}

      iex> create_wing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wing(attrs \\ %{}) do
    %Wing{}
    |> Wing.changeset(attrs)
    |> Repo.insert(skip_wing_slug: true)
  end

  @doc """
  Updates a wing.

  ## Examples

      iex> update_wing(wing, %{field: new_value})
      {:ok, %Wing{}}

      iex> update_wing(wing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wing(%Wing{} = wing, attrs) do
    wing
    |> Wing.changeset(attrs)
    |> Repo.update(skip_wing_slug: true)
  end

  @doc """
  Deletes a wing.

  ## Examples

      iex> delete_wing(wing)
      {:ok, %Wing{}}

      iex> delete_wing(wing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wing(%Wing{} = wing) do
    Repo.delete(wing, skip_wing_slug: true)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wing changes.

  ## Examples

      iex> change_wing(wing)
      %Ecto.Changeset{data: %Wing{}}

  """
  def change_wing(%Wing{} = wing, attrs \\ %{}) do
    Wing.changeset(wing, attrs)
  end
end
