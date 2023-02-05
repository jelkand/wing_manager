defmodule WingManagerWeb.LiveAuth do
  import Phoenix.Component
  # below is needed for redirect
  # import Phoenix.LiveView

  @moduledoc "Helpers to assist with loading the user from the session into the socket"
  @claims %{"typ" => "access"}
  @token_key "guardian_default_token"

  def load_user(token) do
    case Guardian.decode_and_verify(WingManager.Accounts.Guardian, token, @claims) do
      {:ok, claims} ->
        WingManager.Accounts.Guardian.resource_from_claims(claims)

      _ ->
        {:error, :not_authorized}
    end
  end

  # def load_user(_), do: {:error, :not_authorized}

  # Only loads auth, does not _require_ auth
  def on_mount(:default, _params, %{@token_key => guardian_token} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        {:ok, user} = load_user(guardian_token)
        user
      end)

    {:cont, socket}
    #   {:halt, redirect(socket, to: "/login")}
  end
end
