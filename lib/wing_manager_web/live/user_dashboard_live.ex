defmodule WingManagerWeb.UserDashboardLive do
  use WingManagerWeb, :live_view

  # alias WingManager.Accounts
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      hello world
      <%!-- <.header class="text-center">
        Forgot your password?
        <:subtitle>We'll send a password reset link to your inbox</:subtitle>
      </.header>

      <.simple_form :let={f} id="reset_password_form" for={:user} phx-submit="send_email">
        .<.form_field type="email_input" form={f} field={:email} required />
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full">
            Send password reset instructions
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center mt-4 text-gray-700 dark:text-gray-400">
        <.a
          to={~p"/users/register"}
          label="Register"
          class="dark:hover:text-gray-200  hover:text-gray-900 hover:underline"
        /> |
        <.a
          to={~p"/users/log_in"}
          label="Log in"
          class="dark:hover:text-gray-200 hover:text-gray-900 hover:underline"
        />
      </p> --%>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    IO.inspect("hi")
    {:ok, socket}
  end

  def handle_event("my_event", _event, socket) do
    {:noreply, socket}
  end
end
