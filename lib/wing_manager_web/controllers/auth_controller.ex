defmodule WingManagerWeb.AuthController do
  use WingManagerWeb, :controller
  plug(Ueberauth)

  alias WingManager.{Accounts, Accounts.Guardian}

  def request(_conn, _params) do
    # Present an authentication challenge to the user
  end

  def callback(%{assigns: %{ueberauth_auth: auth_data}} = conn, _params) do
    case Accounts.get_or_register_by_discord_id(auth_data) do
      {:ok, account} ->
        conn
        |> Guardian.Plug.sign_in(account)
        |> redirect(to: ~p"/")

      {:error, _error_changeset} ->
        conn
        |> put_flash(:error, "Authentication failed.")
        |> redirect(to: ~p"/  ")
    end
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    # Tell the user something went wrong
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: ~p"/")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: ~p"/")
  end
end
