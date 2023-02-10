defmodule WingManagerWeb.KillLive.FormComponent do
  use WingManagerWeb, :live_component

  alias WingManager.Scoring

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage kill records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="kill-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :target}} type="text" label="Target" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Kill</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{kill: kill} = assigns, socket) do
    changeset = Scoring.change_kill(kill)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"kill" => kill_params}, socket) do
    changeset =
      socket.assigns.kill
      |> Scoring.change_kill(kill_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"kill" => kill_params}, socket) do
    save_kill(socket, socket.assigns.action, kill_params)
  end

  defp save_kill(socket, :edit, kill_params) do
    case Scoring.update_kill(socket.assigns.kill, kill_params, socket.assigns.current_wing.slug) do
      {:ok, _kill} ->
        {:noreply,
         socket
         |> put_flash(:info, "Kill updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_kill(socket, :new, kill_params) do
    case Scoring.create_kill(kill_params) do
      {:ok, _kill} ->
        {:noreply,
         socket
         |> put_flash(:info, "Kill created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
