defmodule WingManagerWeb.AuthController do
  use WingManagerWeb, :controller
  plug Ueberauth

  def request(_conn, _params) do
    # Present an authentication challenge to the user
  end

  def callback(%{assigns: %{ueberauth_auth: auth_data}} = conn, _params) do
    # IO.inspect(auth_data)
    # Find the account if it exists or create it if it doesn't

    conn
  end

  def callback(%{assigns: %{ueberauth_failure: _}} = conn, _params) do
    # Tell the user something went wrong
    conn
    |> put_flash(:error, "Authentication failed.")
    |> redirect(to: ~p"/register")
  end
end
