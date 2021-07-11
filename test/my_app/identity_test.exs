defmodule MyApp.IdentityTest do
  use MyApp.DataCase

  alias MyApp.Identity

  describe "identity_accounts" do
    alias MyApp.Identity.Account

    @valid_attrs %{email: "some email", password_hash: "some password_hash"}
    @update_attrs %{email: "some updated email", password_hash: "some updated password_hash"}
    @invalid_attrs %{email: nil, password_hash: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Identity.create_account()

      account
    end

    test "list_identity_accounts/0 returns all identity_accounts" do
      account = account_fixture()
      assert Identity.list_identity_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Identity.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Identity.create_account(@valid_attrs)
      assert account.email == "some email"
      assert account.password_hash == "some password_hash"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Identity.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Identity.update_account(account, @update_attrs)
      assert account.email == "some updated email"
      assert account.password_hash == "some updated password_hash"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Identity.update_account(account, @invalid_attrs)
      assert account == Identity.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Identity.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Identity.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Identity.change_account(account)
    end
  end

  describe "identity_profiles" do
    alias MyApp.Identity.Profile

    @valid_attrs %{username: "some username"}
    @update_attrs %{username: "some updated username"}
    @invalid_attrs %{username: nil}

    def profile_fixture(attrs \\ %{}) do
      {:ok, profile} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Identity.create_profile()

      profile
    end

    test "list_identity_profiles/0 returns all identity_profiles" do
      profile = profile_fixture()
      assert Identity.list_identity_profiles() == [profile]
    end

    test "get_profile!/1 returns the profile with given id" do
      profile = profile_fixture()
      assert Identity.get_profile!(profile.id) == profile
    end

    test "create_profile/1 with valid data creates a profile" do
      assert {:ok, %Profile{} = profile} = Identity.create_profile(@valid_attrs)
      assert profile.username == "some username"
    end

    test "create_profile/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Identity.create_profile(@invalid_attrs)
    end

    test "update_profile/2 with valid data updates the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{} = profile} = Identity.update_profile(profile, @update_attrs)
      assert profile.username == "some updated username"
    end

    test "update_profile/2 with invalid data returns error changeset" do
      profile = profile_fixture()
      assert {:error, %Ecto.Changeset{}} = Identity.update_profile(profile, @invalid_attrs)
      assert profile == Identity.get_profile!(profile.id)
    end

    test "delete_profile/1 deletes the profile" do
      profile = profile_fixture()
      assert {:ok, %Profile{}} = Identity.delete_profile(profile)
      assert_raise Ecto.NoResultsError, fn -> Identity.get_profile!(profile.id) end
    end

    test "change_profile/1 returns a profile changeset" do
      profile = profile_fixture()
      assert %Ecto.Changeset{} = Identity.change_profile(profile)
    end
  end
end
