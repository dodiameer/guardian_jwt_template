defmodule MyApp.Repo.Migrations.CreateIdentityProfiles do
  use Ecto.Migration

  def change do
    create table(:identity_profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string

      add :account, references(:identity_accounts, on_delete: :delete_all, type: :binary_id),
        null: false,
        unique: true

      timestamps()
    end

    create unique_index(:identity_profiles, [:username])
    create index(:identity_profiles, [:account])
  end
end
