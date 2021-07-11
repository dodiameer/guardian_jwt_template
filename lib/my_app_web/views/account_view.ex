defmodule MyAppWeb.AccountView do
  use MyAppWeb, :view
  alias MyAppWeb.AccountView

  def render("account.token.json", %{account: account, token: token}) do
    %{data: %{account: render_one(account, AccountView, "account.json"), token: token}}
  end

  def render("logout.json", _) do
    %{data: %{success: true}}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id, email: account.email}
  end
end
