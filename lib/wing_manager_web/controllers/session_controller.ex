defmodule WingManagerWeb.SessionController do
  use WingManagerWeb, :controller

  def render(conn, _params) do
    render(conn, :new, changeset: conn, action: "/login")
  end
end
