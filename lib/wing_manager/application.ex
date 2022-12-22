defmodule WingManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WingManagerWeb.Telemetry,
      # Start the Ecto repository
      WingManager.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WingManager.PubSub},
      # Start Finch
      {Finch, name: WingManager.Finch},
      # Start the Endpoint (http/https)
      WingManagerWeb.Endpoint
      # Start a worker by calling: WingManager.Worker.start_link(arg)
      # {WingManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WingManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WingManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
