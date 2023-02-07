defmodule WingManagerWeb.TenantLive.FormComponent do
  use WingManagerWeb, :live_component

  alias WingManager.Wing

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tenant records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="tenant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.form_field form={f} field={:name} type="text_input" label="Name" />
        <.form_field form={f} field={:slug} type="text_input" label="Slug" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tenant</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tenant: tenant} = assigns, socket) do
    changeset = Wing.change_tenant(tenant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tenant" => tenant_params}, socket) do
    changeset =
      socket.assigns.tenant
      |> Wing.change_tenant(tenant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tenant" => tenant_params}, socket) do
    save_tenant(socket, socket.assigns.action, tenant_params)
  end

  defp save_tenant(socket, :edit, tenant_params) do
    case Wing.update_tenant(socket.assigns.tenant, tenant_params) do
      {:ok, _tenant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenant updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tenant(socket, :new, tenant_params) do
    case Wing.create_tenant(tenant_params) do
      {:ok, _tenant} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenant created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
