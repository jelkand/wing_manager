defmodule WingManager.WingTest do
  use WingManager.DataCase

  alias WingManager.Wing

  describe "tenants" do
    alias WingManager.Wing.Tenant

    import WingManager.WingFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_tenants/0 returns all tenants" do
      tenant = tenant_fixture()
      assert Wing.list_tenants() == [tenant]
    end

    test "get_tenant!/1 returns the tenant with given id" do
      tenant = tenant_fixture()
      assert Wing.get_tenant!(tenant.id) == tenant
    end

    test "create_tenant/1 with valid data creates a tenant" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Tenant{} = tenant} = Wing.create_tenant(valid_attrs)
      assert tenant.name == "some name"
      assert tenant.slug == "some slug"
    end

    test "create_tenant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Wing.create_tenant(@invalid_attrs)
    end

    test "update_tenant/2 with valid data updates the tenant" do
      tenant = tenant_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Tenant{} = tenant} = Wing.update_tenant(tenant, update_attrs)
      assert tenant.name == "some updated name"
      assert tenant.slug == "some updated slug"
    end

    test "update_tenant/2 with invalid data returns error changeset" do
      tenant = tenant_fixture()
      assert {:error, %Ecto.Changeset{}} = Wing.update_tenant(tenant, @invalid_attrs)
      assert tenant == Wing.get_tenant!(tenant.id)
    end

    test "delete_tenant/1 deletes the tenant" do
      tenant = tenant_fixture()
      assert {:ok, %Tenant{}} = Wing.delete_tenant(tenant)
      assert_raise Ecto.NoResultsError, fn -> Wing.get_tenant!(tenant.id) end
    end

    test "change_tenant/1 returns a tenant changeset" do
      tenant = tenant_fixture()
      assert %Ecto.Changeset{} = Wing.change_tenant(tenant)
    end
  end
end
