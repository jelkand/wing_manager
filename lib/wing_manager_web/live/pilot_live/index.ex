defmodule WingManagerWeb.PilotLive.Index do
  use WingManagerWeb, :live_view
  on_mount WingManagerWeb.LiveAuth
  on_mount WingManagerWeb.LiveTenant

  alias WingManager.Personnel
  alias WingManager.Personnel.Pilot

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :pilots, list_pilots())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pilot")
    |> assign(:pilot, Personnel.get_pilot!(id, "cjtf"))
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
    pilot = Personnel.get_pilot!(id, "cjtf")
    {:ok, _} = Personnel.delete_pilot(pilot, "cjtf")

    {:noreply, assign(socket, :pilots, list_pilots())}
  end

  defp list_pilots do
    Personnel.list_pilots("cjtf")
  end
end
