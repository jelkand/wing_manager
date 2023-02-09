defmodule WingManagerWeb.UserSettingsLive do
  use WingManagerWeb, :live_view

  alias WingManager.Accounts

  def render(assigns) do
    ~H"""
    <%= if @current_user.email do %>
      <.header>Change Email</.header>

      <.simple_form
        :let={f}
        id="email_form"
        for={@email_changeset}
        phx-submit="update_email"
        phx-change="validate_email"
      >
        <.error :if={@email_changeset.action == :insert}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.form_field form={f} field={:email} type="email_input" label="Email" required />

        <.form_field
          form={f}
          field={:current_password}
          name="current_password"
          id="current_password_for_email"
          type="password_input"
          label="Current password"
          value={@email_form_current_password}
          required
        />
        <:actions>
          <.button phx-disable-with="Changing...">Change Email</.button>
        </:actions>
      </.simple_form>

      <%!-- TODO: controls for oauth users to set their email --%>
    <% else %>
      <.header>Email authentication for Discord users is coming in a future update.</.header>
      <%!-- <.header>Set Email</.header>

      <.simple_form
        :let={f}
        id="email_form"
        for={@email_changeset}
        phx-submit="update_email"
        phx-change="validate_email"
      >
        <.error :if={@email_changeset.action == :insert}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.form_field form={f} field={:email} type="email_input" label="Email" required />
        <:actions>
          <.button phx-disable-with="Changing...">Change Email</.button>
        </:actions>
      </.simple_form> --%>
    <% end %>
    <hr />
    <%= if @current_user.updated_password_at do %>
      <.header>Change Password</.header>

      <.simple_form
        :let={f}
        id="password_form"
        for={@password_changeset}
        action={~p"/users/log_in?_action=password_updated"}
        method="post"
        phx-change="validate_password"
        phx-submit="update_password"
        phx-trigger-action={@trigger_submit}
      >
        <.error :if={@password_changeset.action == :insert}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={{f, :email}} type="hidden" value={@current_email} />

        <.form_field form={f} field={:password} type="password_input" label="New password" required />
        <.form_field
          type="password_input"
          form={f}
          field={:password_confirmation}
          label="Confirm new password"
          required
        />
        <.form_field
          field={:current_password}
          form={f}
          name="current_password"
          type="password_input"
          label="Current password"
          id="current_password_for_password"
          value={@current_password}
          required
        />
        <:actions>
          <.button phx-disable-with="Changing...">Change Password</.button>
        </:actions>
      </.simple_form>
    <% else %>
      <.header>Password authentication for Discord users is coming in a future update.</.header>
    <% end %>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    IO.inspect(user, label: "user")

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:password_changeset, Accounts.change_user_password(user))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    email_changeset = Accounts.change_user_email(socket.assigns.current_user, user_params)

    socket =
      assign(socket,
        email_changeset: Map.put(email_changeset, :action, :validate),
        email_form_current_password: password
      )

    {:noreply, socket}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, put_flash(socket, :info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_changeset, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    password_changeset = Accounts.change_user_password(socket.assigns.current_user, user_params)

    {:noreply,
     socket
     |> assign(:password_changeset, Map.put(password_changeset, :action, :validate))
     |> assign(:current_password, password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        socket =
          socket
          |> assign(:trigger_submit, true)
          |> assign(:password_changeset, Accounts.change_user_password(user, user_params))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :password_changeset, changeset)}
    end
  end
end
