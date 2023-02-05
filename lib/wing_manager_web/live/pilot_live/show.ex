defmodule WingManagerWeb.PilotLive.Show do
  use WingManagerWeb, :live_view
  on_mount WingManagerWeb.LiveAuth
  on_mount WingManagerWeb.LiveTenant

  alias WingManager.Personnel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pilot, Personnel.get_pilot!(id, "cjtf"))}
  end

  defp page_title(:show), do: "Show Pilot"
  defp page_title(:edit), do: "Edit Pilot"
end
