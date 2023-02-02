defmodule WingManager.Accounts.Plugs.PopulateCurrentUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{private: %{guardian_default_resource: current_user}} = conn, _opts) do
    assign(conn, :current_user, current_user)
  end

  def call(conn, _opts) do
    assign(conn, :current_user, nil)
  end
end
