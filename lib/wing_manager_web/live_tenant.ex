defmodule WingManagerWeb.LiveTenant do
  use WingManagerWeb, :verified_routes
  import Phoenix.Component
  alias WingManager.Wing
  @tenant_param "wing"

  defp mount_current_tenant(session, socket) do
    case session do
      %{@tenant_param => tenant_slug} ->
        Phoenix.Component.assign_new(socket, :current_tenant, fn ->
          Wing.get_tenant_by_slug(tenant_slug)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :current_tenant, fn -> nil end)
    end
  end

  def on_mount(:mount_current_tenant, _params, session, socket) do
    {:cont, mount_current_tenant(session, socket)}
  end

  def on_mount(:ensure_tenant, _params, session, socket) do
    socket = mount_current_tenant(session, socket)

    if socket.assigns.current_tenant do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must select a wing to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/tenants")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_has_tenant, _params, session, socket) do
    socket = mount_current_tenant(session, socket)

    if socket.assigns.current_tenant do
      {:halt, Phoenix.LiveView.redirect(socket, to: tenant_home_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp tenant_home_path(socket), do: ~p"/#{socket.assigns.current_tenant.slug}/pilots"
end
