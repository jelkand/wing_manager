defmodule WingManagerWeb.PageController do
  use WingManagerWeb, :controller

  def home(conn, _params) do
    # current_user =
    #   conn
    #   |> Map.get(:private)
    #   |> Map.get(:guardian_default_resource)
    conn
    |> IO.inspect()
    |> render(:home)
  end
end
