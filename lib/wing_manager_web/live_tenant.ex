defmodule WingManagerWeb.LiveTenant do
  import Phoenix.Component
  alias WingManager.Wing
  @tenant_param "wing"

  # loads tenant but does not enforce it
  def on_mount(
        :default,
        %{@tenant_param => tenant_slug},
        _session,
        socket
      ) do
    socket =
      assign_new(socket, :current_tenant, fn ->
        Wing.get_tenant_by_slug(tenant_slug)
      end)

    {:cont, socket}
  end
end
