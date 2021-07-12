defmodule MyApp.Identity.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Identity.Profile

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "identity_accounts" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_one :profile, Profile
    # TODO: add permissions - currently added in database table only
    # field :premissions, :map, default: %{read_self: true, write_self: true}

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+/,
      message: "Invalid email"
    )
    |> validate_format(
      :password,
      ~r/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$/,
      message:
        " Minimum eight characters, at least one upper case English letter, one lower case English letter, one number and one special character"
    )
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
