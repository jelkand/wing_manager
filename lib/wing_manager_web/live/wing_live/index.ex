defmodule WingManagerWeb.WingLive.Index do
  use WingManagerWeb, :live_view

  alias WingManager.Organizations
  alias WingManager.Organizations.Wing

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :wings, list_wings())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Wing")
    |> assign(:wing, Organizations.get_wing!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Wing")
    |> assign(:wing, %Wing{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Wings")
    |> assign(:wing, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    wing = Organizations.get_wing!(id)
    {:ok, _} = Organizations.delete_wing(wing)

    {:noreply, assign(socket, :wings, list_wings())}
  end

  defp list_wings do
    Organizations.list_wings()
  end
end
