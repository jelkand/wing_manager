defmodule WingManagerWeb.WingLive.FormComponent do
  use WingManagerWeb, :live_component

  alias WingManager.Organizations

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage wing records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="wing-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.form_field form={f} field={:name} type="text_input" label="Name" />
        <.form_field form={f} field={:slug} type="text_input" label="Slug" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Wing</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{wing: wing} = assigns, socket) do
    changeset = Organizations.change_wing(wing)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"wing" => wing_params}, socket) do
    changeset =
      socket.assigns.wing
      |> Organizations.change_wing(wing_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"wing" => wing_params}, socket) do
    save_wing(socket, socket.assigns.action, wing_params)
  end

  defp save_wing(socket, :edit, wing_params) do
    case Organizations.update_wing(socket.assigns.wing, wing_params) do
      {:ok, _wing} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wing updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_wing(socket, :new, wing_params) do
    case Organizations.create_wing(wing_params) do
      {:ok, _wing} ->
        {:noreply,
         socket
         |> put_flash(:info, "Wing created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
