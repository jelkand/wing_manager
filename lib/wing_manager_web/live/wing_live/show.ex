defmodule WingManagerWeb.WingLive.Show do
  use WingManagerWeb, :live_view

  alias WingManager.Organizations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:wing, Organizations.get_wing!(id))}
  end

  defp page_title(:show), do: "Show Wing"
  defp page_title(:edit), do: "Edit Wing"
end
