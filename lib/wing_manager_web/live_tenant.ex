defmodule WingManagerWeb.LiveWing do
  use WingManagerWeb, :verified_routes
  # import Phoenix.Component
  alias WingManager.Organizations
  @wing_param "wing"

  defp mount_current_wing(params, socket) do
    case params do
      %{@wing_param => wing_slug} ->
        Phoenix.Component.assign_new(socket, :current_wing, fn ->
          Organizations.get_wing_by_slug(wing_slug)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :current_wing, fn -> nil end)
    end
  end

  def on_mount(:mount_current_wing, params, _session, socket) do
    {:cont, mount_current_wing(params, socket)}
  end

  def on_mount(:ensure_wing, params, _session, socket) do
    socket = mount_current_wing(params, socket)

    if socket.assigns.current_wing do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must select a wing to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/wings")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_has_wing, params, _session, socket) do
    socket = mount_current_wing(params, socket)

    if socket.assigns.current_wing do
      {:halt, Phoenix.LiveView.redirect(socket, to: wing_home_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp wing_home_path(socket), do: ~p"/#{socket.assigns.current_wing.slug}/pilots"
end
