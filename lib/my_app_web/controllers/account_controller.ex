defmodule MyAppWeb.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Identity
  alias MyApp.Identity.{Guardian}

  @jwt_cookie_options [
    sign: true,
    max_age: Identity.get_token_ttl(:refresh, %{seconds: true}),
    http_only: true
  ]

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
    conn
    |> delete_resp_cookie("my_app_rjwt", @jwt_cookie_options)
    |> render("logout.json")
  end

  def me(conn, _params) do
    account = Guardian.Plug.current_resource(conn)

    conn
    |> render("account.json", account: account)
  end

  def refresh(conn, _params) do
    refresh_token_cookie = conn.req_cookies["my_app_rjwt"]
    # ? Decode the cookie into a JWT
    case MyApp.Utilities.decode_signed_cookie(refresh_token_cookie) do
      nil ->
        {:error, :no_refresh_token}

      old_refresh_token ->
        old_access_token = Guardian.Plug.current_token(conn)

        with {:ok, account, _claims} <-
               Guardian.resource_from_token(old_refresh_token, %{"typ" => "refresh"}) do
          Guardian.revoke(old_access_token)
          Guardian.revoke(old_refresh_token)

          conn
          |> account_with_token(account)
        end
    end
  end

  defp account_with_token(conn, account) do
    {:ok, token, refresh_token} = Identity.generate_token(account)

    conn
    |> put_resp_cookie("my_app_rjwt", refresh_token, @jwt_cookie_options)
    |> render("account.token.json", account: account, token: token)
  end
end
