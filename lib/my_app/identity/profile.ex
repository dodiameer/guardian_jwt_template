defmodule MyApp.Identity.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias MyApp.Identity.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "identity_profiles" do
    field :username, :string
    belongs_to :account, Account

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
    |> validate_format(:username, ~r/^[a-z0-9-]{3,15}$/,
      message:
        "Username must contain only letters, numbers, and hyphens, and be between 3-15 characters"
    )
  end
end
