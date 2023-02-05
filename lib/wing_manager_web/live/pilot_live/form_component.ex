defmodule WingManagerWeb.PilotLive.FormComponent do
  use WingManagerWeb, :live_component

  alias WingManager.Personnel

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage pilot records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="pilot-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :callsign}} type="text" label="Callsign" />
        <.input field={{f, :title}} type="text" label="Title" />
        <.input
          field={{f, :roles}}
          type="select"
          multiple
          label="Roles"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Pilot</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{pilot: pilot} = assigns, socket) do
    changeset = Personnel.change_pilot(pilot)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"pilot" => pilot_params}, socket) do
    changeset =
      socket.assigns.pilot
      |> Personnel.change_pilot(pilot_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"pilot" => pilot_params}, socket) do
    save_pilot(socket, socket.assigns.action, pilot_params)
  end

  defp save_pilot(socket, :edit, pilot_params) do
    case Personnel.update_pilot(socket.assigns.pilot, pilot_params, "cjtf") do
      {:ok, _pilot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pilot updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_pilot(socket, :new, pilot_params) do
    case Personnel.create_pilot(pilot_params) do
      {:ok, _pilot} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pilot created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
