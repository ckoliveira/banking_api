defmodule BankingApi.Passwords.Inputs.Create do
  import Ecto.Changeset

  alias BankingApi.Passwords.Schemas.Password

  @required [:password, :salt]
  @optional []
  @default_salt 77

  def changeset(params) do
    %Password{}
    |> cast(params, @required ++ @optional)
    |> validate_length(:password, min: 8)
    |> hash_password()
  end

  def hash_password(%{valid?: false} = changeset) do
    changeset
  end

  def hash_password(%Ecto.Changeset{changes: %{password: pwd}} = changeset) do
    password_hash = Argon2.hash_pwd_salt(pwd, salt: @default_salt)

    changeset
    |> put_change(:salt, @default_salt)
    |> put_change(:password_hash, password_hash)
  end
end
