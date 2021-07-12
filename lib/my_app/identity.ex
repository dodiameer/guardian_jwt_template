defmodule MyApp.Identity do
  @moduledoc """
  The Identity context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Identity.Account

  @doc """
  Returns the list of identity_accounts.

  ## Examples

      iex> list_identity_accounts()
      [%Account{}, ...]

  """
  def list_identity_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  alias MyApp.Identity.Profile

  @doc """
  Returns the list of identity_profiles.

  ## Examples

      iex> list_identity_profiles()
      [%Profile{}, ...]

  """
  def list_identity_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile!(id), do: Repo.get!(Profile, id)

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(attrs \\ %{}) do
    %Profile{}
    |> Profile.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  @doc """
  Validates an account's email and password
  """
  def authenticate_account(email, password) do
    query = from a in Account, where: a.email == ^email

    case Repo.one(query) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}

      account ->
        if Pbkdf2.verify_pass(password, account.password_hash) do
          {:ok, account}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  alias MyApp.Identity.Guardian

  def generate_token(%Account{} = account) do
    with {:ok, token, _claims} <-
           Guardian.encode_and_sign(account, %{}, ttl: get_token_ttl(:access, %{seconds: false})),
         {:ok, refresh_token, _claims} <-
           Guardian.encode_and_sign(account, %{},
             token_type: "refresh",
             ttl: get_token_ttl(:refresh, %{seconds: false})
           ) do
      {:ok, token, refresh_token}
    end
  end

  def get_token_ttl(:access, opts) do
    if opts.seconds do
      60 * 15
    else
      {15, :minutes}
    end
  end

  def get_token_ttl(:refresh, opts) do
    if opts.seconds do
      60 * 60 * 24 * 7 * 4
    else
      {4, :weeks}
    end
  end
end
