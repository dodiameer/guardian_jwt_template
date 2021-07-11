defmodule MyApp.Identity.Guardian do
  use Guardian, otp_app: :my_app

  alias MyApp.Identity

  def subject_for_token(account, _claims) do
    {:ok, to_string(account.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    account = Identity.get_account!(id)
    {:ok, account}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
