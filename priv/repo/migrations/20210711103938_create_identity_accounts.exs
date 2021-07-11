defmodule MyApp.Repo.Migrations.CreateIdentityAccounts do
  use Ecto.Migration

  def change do
    create table(:identity_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string
      add :permissions, :map

      timestamps()
    end

    create unique_index(:identity_accounts, [:email])
  end
end
