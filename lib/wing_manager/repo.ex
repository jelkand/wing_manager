defmodule WingManager.Repo do
  use Ecto.Repo,
    otp_app: :wing_manager,
    adapter: Ecto.Adapters.Postgres

  require Ecto.Query

  @impl true
  def prepare_query(_operation, query, opts) do
    cond do
      opts[:skip_wing_slug] || opts[:schema_migration] ->
        {query, opts}

      wing_slug = opts[:wing_slug] ->
        {Ecto.Query.where(query, wing_slug: ^wing_slug), opts}

      true ->
        raise "expected wing_slug or skip_wing_slug to be set"
    end
  end

  @tenant_key {__MODULE__, :wing_slug}

  def put_wing_slug(wing_slug) do
    Process.put(@tenant_key, wing_slug)
  end

  def get_wing_slug() do
    Process.get(@tenant_key)
  end

  @impl true
  def default_options(_operation) do
    [wing_slug: get_wing_slug()]
  end
end
