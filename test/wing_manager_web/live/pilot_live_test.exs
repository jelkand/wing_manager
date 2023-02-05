defmodule WingManagerWeb.PilotLiveTest do
  use WingManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import WingManager.PersonnelFixtures

  @create_attrs %{callsign: "some callsign", roles: ["option1", "option2"], title: "some title"}
  @update_attrs %{callsign: "some updated callsign", roles: ["option1"], title: "some updated title"}
  @invalid_attrs %{callsign: nil, roles: [], title: nil}

  defp create_pilot(_) do
    pilot = pilot_fixture()
    %{pilot: pilot}
  end

  describe "Index" do
    setup [:create_pilot]

    test "lists all pilots", %{conn: conn, pilot: pilot} do
      {:ok, _index_live, html} = live(conn, ~p"/pilots")

      assert html =~ "Listing Pilots"
      assert html =~ pilot.callsign
    end

    test "saves new pilot", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pilots")

      assert index_live |> element("a", "New Pilot") |> render_click() =~
               "New Pilot"

      assert_patch(index_live, ~p"/pilots/new")

      assert index_live
             |> form("#pilot-form", pilot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pilot-form", pilot: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/pilots")

      assert html =~ "Pilot created successfully"
      assert html =~ "some callsign"
    end

    test "updates pilot in listing", %{conn: conn, pilot: pilot} do
      {:ok, index_live, _html} = live(conn, ~p"/pilots")

      assert index_live |> element("#pilots-#{pilot.id} a", "Edit") |> render_click() =~
               "Edit Pilot"

      assert_patch(index_live, ~p"/pilots/#{pilot}/edit")

      assert index_live
             |> form("#pilot-form", pilot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#pilot-form", pilot: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/pilots")

      assert html =~ "Pilot updated successfully"
      assert html =~ "some updated callsign"
    end

    test "deletes pilot in listing", %{conn: conn, pilot: pilot} do
      {:ok, index_live, _html} = live(conn, ~p"/pilots")

      assert index_live |> element("#pilots-#{pilot.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pilot-#{pilot.id}")
    end
  end

  describe "Show" do
    setup [:create_pilot]

    test "displays pilot", %{conn: conn, pilot: pilot} do
      {:ok, _show_live, html} = live(conn, ~p"/pilots/#{pilot}")

      assert html =~ "Show Pilot"
      assert html =~ pilot.callsign
    end

    test "updates pilot within modal", %{conn: conn, pilot: pilot} do
      {:ok, show_live, _html} = live(conn, ~p"/pilots/#{pilot}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pilot"

      assert_patch(show_live, ~p"/pilots/#{pilot}/show/edit")

      assert show_live
             |> form("#pilot-form", pilot: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#pilot-form", pilot: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/pilots/#{pilot}")

      assert html =~ "Pilot updated successfully"
      assert html =~ "some updated callsign"
    end
  end
end
