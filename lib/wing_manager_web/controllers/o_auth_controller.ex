defmodule WingManagerWeb.OAuthController do
  use WingManagerWeb, :controller
  plug Ueberauth

  alias WingManager.Accounts
  alias WingManagerWeb.UserAuth

  def request(_conn, _params) do
    # Present an authentication challenge to the user
  end

  def callback(%{assigns: %{ueberauth_auth: auth_data}} = conn, _params) do
    case Accounts.get_or_register_by_discord_id(auth_data) do
      {:ok, account} ->
        conn
        |> UserAuth.log_in_user(account)

      {:error, _error_changeset} ->
        conn
        |> put_flash(:error, "Authentication failed.")
        |> redirect(to: ~p"/")
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
    |> UserAuth.log_out_user()
    |> redirect(to: ~p"/")
  end
end
