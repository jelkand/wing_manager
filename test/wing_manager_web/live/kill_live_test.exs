defmodule WingManagerWeb.KillLiveTest do
  use WingManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import WingManager.ScoringFixtures

  @create_attrs %{target: "some target"}
  @update_attrs %{target: "some updated target"}
  @invalid_attrs %{target: nil}

  defp create_kill(_) do
    kill = kill_fixture()
    %{kill: kill}
  end

  describe "Index" do
    setup [:create_kill]

    test "lists all kills", %{conn: conn, kill: kill} do
      {:ok, _index_live, html} = live(conn, ~p"/kills")

      assert html =~ "Listing Kills"
      assert html =~ kill.target
    end

    test "saves new kill", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/kills")

      assert index_live |> element("a", "New Kill") |> render_click() =~
               "New Kill"

      assert_patch(index_live, ~p"/kills/new")

      assert index_live
             |> form("#kill-form", kill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#kill-form", kill: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/kills")

      assert html =~ "Kill created successfully"
      assert html =~ "some target"
    end

    test "updates kill in listing", %{conn: conn, kill: kill} do
      {:ok, index_live, _html} = live(conn, ~p"/kills")

      assert index_live |> element("#kills-#{kill.id} a", "Edit") |> render_click() =~
               "Edit Kill"

      assert_patch(index_live, ~p"/kills/#{kill}/edit")

      assert index_live
             |> form("#kill-form", kill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#kill-form", kill: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/kills")

      assert html =~ "Kill updated successfully"
      assert html =~ "some updated target"
    end

    test "deletes kill in listing", %{conn: conn, kill: kill} do
      {:ok, index_live, _html} = live(conn, ~p"/kills")

      assert index_live |> element("#kills-#{kill.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#kill-#{kill.id}")
    end
  end

  describe "Show" do
    setup [:create_kill]

    test "displays kill", %{conn: conn, kill: kill} do
      {:ok, _show_live, html} = live(conn, ~p"/kills/#{kill}")

      assert html =~ "Show Kill"
      assert html =~ kill.target
    end

    test "updates kill within modal", %{conn: conn, kill: kill} do
      {:ok, show_live, _html} = live(conn, ~p"/kills/#{kill}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Kill"

      assert_patch(show_live, ~p"/kills/#{kill}/show/edit")

      assert show_live
             |> form("#kill-form", kill: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#kill-form", kill: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/kills/#{kill}")

      assert html =~ "Kill updated successfully"
      assert html =~ "some updated target"
    end
  end
end
