defmodule WingManager.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias WingManager.Repo

  alias WingManager.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_discord_id(discord_id), do: Repo.get_by(User, %{discord_id: discord_id})

  def get_or_register_by_discord_id(%Ueberauth.Auth{uid: uid} = params) do
    if account = get_user_by_discord_id(uid) do
      {:ok, account}
    else
      register(params)
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def register(%Ueberauth.Auth{} = params) do
    %User{}
    |> User.changeset(extract_account_params(params))
    |> Repo.insert()
  end

  defp extract_account_params(%Ueberauth.Auth{
         uid: discord_id,
         extra: %Ueberauth.Auth.Extra{
           raw_info: %{
             user: %{
               "avatar" => discord_avatar_hash,
               "discriminator" => discord_discriminator,
               "username" => discord_username
             }
           }
         }
       }) do
    %{
      discord_id: discord_id,
      discord_avatar_hash: discord_avatar_hash,
      discord_discriminator: discord_discriminator,
      discord_username: discord_username
    }
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
