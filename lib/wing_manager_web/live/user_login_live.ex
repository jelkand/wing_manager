defmodule WingManagerWeb.UserLoginLive do
  use WingManagerWeb, :live_view
  import Phoenix.HTML.Form, only: [input_value: 2]

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Sign in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form
        :let={f}
        id="login_form"
        for={:user}
        action={~p"/users/log_in"}
        as={:user}
        phx-update="ignore"
      >
        <.form_field type="email_input" form={f} field={:email} label="Email" required />
        <.form_field
          type="password_input"
          form={f}
          field={:password}
          label="Password"
          required
          value={input_value(f, :password)}
        />
        <:actions :let={f}>
          <label class="inline-flex items-center gap-3">
            <.checkbox form={f} field={:remember_me} />
            <div class="text-sm block text-gray-900 dark:text-gray-200">
              Keep me signed in
            </div>
          </label>
          <.a
            to={~p"/users/reset_password"}
            class="text-sm font-semibold text-gray-600 dark:text-gray-400 dark:hover:text-gray-200  hover:text-gray-900 hover:underline "
          >
            Forgot your password?
          </.a>
        </:actions>
        <:actions>
          <.button phx-disable-with="Signing in..." class="w-full">
            Sign in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>

      <hr class="my-4" />

      <.button
        with_icon
        link_type="a"
        to={~p"/auth/discord"}
        phx-disable-with="Redirecting to Discord..."
        class="w-full bg-discord hover:bg-purple-700"
      >
        <svg
          class="w-5 h-5 fill-white"
          xmlns="http://www.w3.org/2000/svg"
          data-name="Layer 1"
          viewBox="0 0 16 16"
        >
          <path d="M13.545 2.907a13.227 13.227 0 0 0-3.257-1.011.05.05 0 0 0-.052.025c-.141.25-.297.577-.406.833a12.19 12.19 0 0 0-3.658 0 8.258 8.258 0 0 0-.412-.833.051.051 0 0 0-.052-.025c-1.125.194-2.22.534-3.257 1.011a.041.041 0 0 0-.021.018C.356 6.024-.213 9.047.066 12.032c.001.014.01.028.021.037a13.276 13.276 0 0 0 3.995 2.02.05.05 0 0 0 .056-.019c.308-.42.582-.863.818-1.329a.05.05 0 0 0-.01-.059.051.051 0 0 0-.018-.011 8.875 8.875 0 0 1-1.248-.595.05.05 0 0 1-.02-.066.051.051 0 0 1 .015-.019c.084-.063.168-.129.248-.195a.05.05 0 0 1 .051-.007c2.619 1.196 5.454 1.196 8.041 0a.052.052 0 0 1 .053.007c.08.066.164.132.248.195a.051.051 0 0 1-.004.085 8.254 8.254 0 0 1-1.249.594.05.05 0 0 0-.03.03.052.052 0 0 0 .003.041c.24.465.515.909.817 1.329a.05.05 0 0 0 .056.019 13.235 13.235 0 0 0 4.001-2.02.049.049 0 0 0 .021-.037c.334-3.451-.559-6.449-2.366-9.106a.034.034 0 0 0-.02-.019Zm-8.198 7.307c-.789 0-1.438-.724-1.438-1.612 0-.889.637-1.613 1.438-1.613.807 0 1.45.73 1.438 1.613 0 .888-.637 1.612-1.438 1.612Zm5.316 0c-.788 0-1.438-.724-1.438-1.612 0-.889.637-1.613 1.438-1.613.807 0 1.451.73 1.438 1.613 0 .888-.631 1.612-1.438 1.612Z" />
        </svg>
        Sign in with Discord <span aria-hidden="true">→</span>
      </.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email), temporary_assigns: [email: nil]}
  end
end
