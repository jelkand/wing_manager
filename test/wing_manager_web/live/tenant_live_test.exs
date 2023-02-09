defmodule WingManagerWeb.WingLiveTest do
  use WingManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import WingManager.OrganizationsFixtures

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  defp create_wing(_) do
    wing = wing_fixture()
    %{wing: wing}
  end

  describe "Index" do
    setup [:create_wing]

    test "lists all wings", %{conn: conn, wing: wing} do
      {:ok, _index_live, html} = live(conn, ~p"/wings")

      assert html =~ "Listing Wings"
      assert html =~ wing.name
    end

    test "saves new wing", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/wings")

      assert index_live |> element("a", "New Wing") |> render_click() =~
               "New Wing"

      assert_patch(index_live, ~p"/wings/new")

      assert index_live
             |> form("#wing-form", wing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#wing-form", wing: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/wings")

      assert html =~ "Wing created successfully"
      assert html =~ "some name"
    end

    test "updates wing in listing", %{conn: conn, wing: wing} do
      {:ok, index_live, _html} = live(conn, ~p"/wings")

      assert index_live |> element("#wings-#{wing.id} a", "Edit") |> render_click() =~
               "Edit Wing"

      assert_patch(index_live, ~p"/wings/#{wing}/edit")

      assert index_live
             |> form("#wing-form", wing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#wing-form", wing: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/wings")

      assert html =~ "Wing updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes wing in listing", %{conn: conn, wing: wing} do
      {:ok, index_live, _html} = live(conn, ~p"/wings")

      assert index_live |> element("#wings-#{wing.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#wing-#{wing.id}")
    end
  end

  describe "Show" do
    setup [:create_wing]

    test "displays wing", %{conn: conn, wing: wing} do
      {:ok, _show_live, html} = live(conn, ~p"/wings/#{wing}")

      assert html =~ "Show Wing"
      assert html =~ wing.name
    end

    test "updates wing within modal", %{conn: conn, wing: wing} do
      {:ok, show_live, _html} = live(conn, ~p"/wings/#{wing}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Wing"

      assert_patch(show_live, ~p"/wings/#{wing}/show/edit")

      assert show_live
             |> form("#wing-form", wing: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#wing-form", wing: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/wings/#{wing}")

      assert html =~ "Wing updated successfully"
      assert html =~ "some updated name"
    end
  end
end
