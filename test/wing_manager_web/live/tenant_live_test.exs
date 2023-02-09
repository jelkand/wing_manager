defmodule WingManagerWeb.WingLiveTest do
  use WingManagerWeb.ConnCase

  import Phoenix.LiveViewTest
  import WingManager.WingFixtures

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  defp create_tenant(_) do
    tenant = tenant_fixture()
    %{tenant: tenant}
  end

  describe "Index" do
    setup [:create_tenant]

    test "lists all tenants", %{conn: conn, tenant: tenant} do
      {:ok, _index_live, html} = live(conn, ~p"/wings")

      assert html =~ "Listing Tenants"
      assert html =~ tenant.name
    end

    test "saves new tenant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/wings")

      assert index_live |> element("a", "New Tenant") |> render_click() =~
               "New Tenant"

      assert_patch(index_live, ~p"/wings/new")

      assert index_live
             |> form("#tenant-form", tenant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tenant-form", tenant: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/wings")

      assert html =~ "Tenant created successfully"
      assert html =~ "some name"
    end

    test "updates tenant in listing", %{conn: conn, tenant: tenant} do
      {:ok, index_live, _html} = live(conn, ~p"/wings")

      assert index_live |> element("#tenants-#{tenant.id} a", "Edit") |> render_click() =~
               "Edit Tenant"

      assert_patch(index_live, ~p"/wings/#{tenant}/edit")

      assert index_live
             |> form("#tenant-form", tenant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#tenant-form", tenant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/wings")

      assert html =~ "Tenant updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes tenant in listing", %{conn: conn, tenant: tenant} do
      {:ok, index_live, _html} = live(conn, ~p"/wings")

      assert index_live |> element("#tenants-#{tenant.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tenant-#{tenant.id}")
    end
  end

  describe "Show" do
    setup [:create_tenant]

    test "displays tenant", %{conn: conn, tenant: tenant} do
      {:ok, _show_live, html} = live(conn, ~p"/wings/#{tenant}")

      assert html =~ "Show Tenant"
      assert html =~ tenant.name
    end

    test "updates tenant within modal", %{conn: conn, tenant: tenant} do
      {:ok, show_live, _html} = live(conn, ~p"/wings/#{tenant}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Tenant"

      assert_patch(show_live, ~p"/wings/#{tenant}/show/edit")

      assert show_live
             |> form("#tenant-form", tenant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#tenant-form", tenant: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/wings/#{tenant}")

      assert html =~ "Tenant updated successfully"
      assert html =~ "some updated name"
    end
  end
end
