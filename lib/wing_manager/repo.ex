defmodule WingManager.Repo do
  use Ecto.Repo,
    otp_app: :wing_manager,
    adapter: Ecto.Adapters.Postgres
end
