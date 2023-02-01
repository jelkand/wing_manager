defmodule WingManagerWeb.RegistrationController do
  use WingManagerWeb, :controller

  def new(conn, _params) do
    render(conn, :new, changeset: conn, action: "/register")
  end
end
