defmodule WingManagerWeb.PageController do
  use WingManagerWeb, :controller

  def home(conn, _params) do
    render(conn, :home, active_tab: :home)
  end
end
