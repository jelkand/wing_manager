defmodule WingManagerWeb.Router do
  use WingManagerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WingManagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug Triplex.ParamPlug,
      param: :wing,
      tenant_handler: &WingManager.Wing.get_tenant_by_slug/1
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug WingManager.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/auth", WingManagerWeb do
    pipe_through [:browser, :auth]
    get "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", WingManagerWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :home

    live_session :authenticated, on_mount: [{WingManagerWeb.LiveAuth, :ensure_authenticated}] do
      live "/wings", TenantLive.Index, :index
      live "/wings/new", TenantLive.Index, :new
      live "/wings/:id/edit", TenantLive.Index, :edit
      live "/wings/:id/show/edit", TenantLive.Show, :edit
      live "/wings/:id", TenantLive.Show, :show
    end
  end

  scope "/:wing", WingManagerWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :home

    live_session :authenticated_and_tenant,
      on_mount: [
        {WingManagerWeb.LiveAuth, :ensure_authenticated},
        {WingManagerWeb.LiveTenant, :ensure_tenant}
      ] do
      live "/pilots", PilotLive.Index, :index
      live "/pilots/new", PilotLive.Index, :new
      live "/pilots/:id/edit", PilotLive.Index, :edit

      live "/pilots/:id", PilotLive.Show, :show
      live "/pilots/:id/show/edit", PilotLive.Show, :edit
    end
  end

  scope "/admin", WingManagerWeb do
    pipe_through [:browser, :auth]
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
end
