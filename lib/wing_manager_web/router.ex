defmodule WingManagerWeb.Router do
  use WingManagerWeb, :router

  import WingManagerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WingManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user

    plug Triplex.ParamPlug,
      param: :wing,
      wing_handler: &WingManager.Organizations.get_wing_by_slug/1
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", WingManagerWeb do
    pipe_through [:browser]
    get "/:provider", OAuthController, :request
    get "/:provider/callback", OAuthController, :callback
  end

  scope "/", WingManagerWeb do
    pipe_through [:browser]

    get "/", PageController, :home

    live_session :authenticated, on_mount: [{WingManagerWeb.UserAuth, :ensure_authenticated}] do
      live "/wings", WingLive.Index, :index
      live "/wings/new", WingLive.Index, :new
      live "/wings/:id/edit", WingLive.Index, :edit
      live "/wings/:id/show/edit", WingLive.Show, :edit
      live "/wings/:id", WingLive.Show, :show
    end
  end

  scope "/:wing", WingManagerWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :home

    live_session :authenticated_and_wing,
      on_mount: [
        {WingManagerWeb.UserAuth, :ensure_authenticated},
        {WingManagerWeb.LiveWing, :ensure_wing}
      ] do
      live "/pilots", PilotLive.Index, :index
      live "/pilots/new", PilotLive.Index, :new
      live "/pilots/:id/edit", PilotLive.Index, :edit

      live "/pilots/:id", PilotLive.Show, :show
      live "/pilots/:id/show/edit", PilotLive.Show, :edit

      live "/kills", KillLive.Index, :index
      live "/kills/new", KillLive.Index, :new
      live "/kills/:id/edit", KillLive.Index, :edit

      live "/kills/:id", KillLive.Show, :show
      live "/kills/:id/show/edit", KillLive.Show, :edit
    end
  end

  scope "/admin", WingManagerWeb do
    pipe_through [:browser, :require_authenticated_user]
  end

  # Other scopes may use custom stacks.
  # scope "/api", WingManagerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:wing_manager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: WingManagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", WingManagerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{WingManagerWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", WingManagerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{WingManagerWeb.UserAuth, :ensure_authenticated}] do
      live "/users/dashboard", UserDashboardLive, :index
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", WingManagerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{WingManagerWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
