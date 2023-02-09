defmodule WingManagerWeb.PageController do
  use WingManagerWeb, :controller

  def home(conn, _params) do
    conn
    |> render(:home)
  end
end
