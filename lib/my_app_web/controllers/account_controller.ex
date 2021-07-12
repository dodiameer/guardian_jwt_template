defmodule MyAppWeb.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Identity
  alias MyApp.Identity.{Guardian}

  action_fallback MyAppWeb.FallbackController

  def register(conn, %{"account" => account_params}) do
    case Identity.create_account(account_params) do
      {:ok, account} ->
        conn
        |> account_with_token(account)

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Identity.authenticate_account(email, password) do
      {:ok, account} ->
        conn
        |> account_with_token(account)

      error ->
        error
    end
  end

  def logout(conn, _params) do
    # Currently does nothing, will be needed to add GuardianDB
    conn
    |> render("logout.json")
  end

  def me(conn, _params) do
    account = Guardian.Plug.current_resource(conn)

    conn
    |> render("account.json", account: account)
  end

  defp account_with_token(conn, account) do
    {:ok, token, refresh_token} = Identity.generate_token(account)

    conn
    |> put_resp_cookie("my_app_rjwt", refresh_token,
      sign: true,
      max_age: Identity.get_token_ttl(:refresh, %{seconds: true}),
      http_only: true
    )
    |> render("account.token.json", account: account, token: token)
  end
end
