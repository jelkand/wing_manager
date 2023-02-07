defmodule WingManagerWeb.PilotLive.Index do
  use WingManagerWeb, :live_view

  alias WingManager.Personnel
  alias WingManager.Personnel.Pilot

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :pilots, list_pilots(socket.assigns.current_tenant.slug))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pilot")
    |> assign(:pilot, Personnel.get_pilot!(id, socket.assigns.current_tenant.slug))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pilot")
    |> assign(:pilot, %Pilot{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pilots")
    |> assign(:pilot, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pilot = Personnel.get_pilot!(id, socket.assigns.current_tenant.slug)
    {:ok, _} = Personnel.delete_pilot(pilot, socket.assigns.current_tenant.slug)

    {:noreply, assign(socket, :pilots, list_pilots(socket.assigns.current_tenant.slug))}
  end

  @impl true
  def handle_event("close_modal", _, %{assigns: %{current_tenant: current_tenant}} = socket) do
    # Go back to the :index live action
    {:noreply, push_patch(socket, to: ~p"/#{current_tenant.slug}/pilots")}
  end

  defp list_pilots(tenant) do
    Personnel.list_pilots(tenant)
  end
end
