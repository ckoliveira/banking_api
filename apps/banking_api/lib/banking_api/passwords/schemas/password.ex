defmodule BankingApi.Passwords.Schemas.Password do
  use Ecto.Schema

  alias BankingApi.Users.Schemas.User

  @default_salt 77

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "passwords" do
    field :password, :string, virtual: true
    field :password_hash, :string, redact: true
    field :salt, :integer, default: @default_salt
    belongs_to :user, User

    timestamps()
  end
end
