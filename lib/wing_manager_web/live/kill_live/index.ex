defmodule WingManagerWeb.KillLive.Index do
  use WingManagerWeb, :live_view

  alias WingManager.Scoring
  alias WingManager.Scoring.Kill

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :kills, list_kills_and_pilots())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Kill")
    |> assign(:kill, Scoring.get_kill!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Kill")
    |> assign(:kill, %Kill{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Kills")
    |> assign(:kill, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    kill = Scoring.get_kill!(id)
    {:ok, _} = Scoring.delete_kill(kill)

    {:noreply, assign(socket, :kills, list_kills_and_pilots())}
  end

  defp list_kills_and_pilots do
    Scoring.list_kills_with_pilots()
    |> IO.inspect()
  end
end
