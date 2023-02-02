defmodule WingManager.Accounts.Guardian do
  use Guardian, otp_app: :wing_manager

  alias WingManager.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  # def subject_for_token(_, _) do
  #   {:error, :reason_for_error}
  # end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  # def log_in(conn, account) do
  #   __MODULE__.Plug.sign_in(conn, account)
  # end
end
