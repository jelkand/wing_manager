defmodule WingManagerWeb.LiveAuth do
  use WingManagerWeb, :verified_routes
  # At some point this should migrate into AuthController
  # import Phoenix.Component
  import Phoenix.Controller, only: [current_path: 1]
  import Plug.Conn

  # below is needed for redirect
  import Phoenix.LiveView

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

  defp mount_current_user(session, socket) do
    case session do
      %{@token_key => guardian_token} ->
        Phoenix.Component.assign_new(socket, :current_user, fn ->
          {:ok, user} = load_user(guardian_token)
          user
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :current_user, fn -> nil end)
    end
  end

  # Only loads auth, does not _require_ auth
  # def on_mount(:default, _params, %{@token_key => guardian_token} = _session, socket) do
  #   socket =
  #     assign_new(socket, :current_user, fn ->
  #       {:ok, user} = load_user(guardian_token)
  #       user
  #     end)

  #   {:cont, socket}
  #   #   {:halt, redirect(socket, to: "/login")}
  # end

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.

  ## `on_mount` arguments

    * `:mount_current_user` - Assigns current_user
      to socket assigns based on user_token, or nil if
      there's no user_token or no matching user.

    * `:ensure_authenticated` - Authenticates the user from the session,
      and assigns the current_user to socket assigns based
      on user_token.
      Redirects to login page if there's no logged user.

    * `:redirect_if_user_is_authenticated` - Authenticates the user from the session.
      Redirects to signed_in_path if there's a logged user.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_user:

      defmodule VanillaPhxWeb.PageLive do
        use VanillaPhxWeb, :live_view

        on_mount {VanillaPhxWeb.UserAuth, :mount_current_user}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{VanillaPhxWeb.UserAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end
  """
  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(session, socket)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the user to be authenticated.

  If you want to enforce the user email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/")
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"
end
