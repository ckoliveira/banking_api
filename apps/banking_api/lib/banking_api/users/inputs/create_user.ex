defmodule BankingApi.Users.Inputs.CreateUser do
  @moduledoc """
  Create, validate and insert a new user in the database
  """

  use BankingApi.Schema

  @required [:name, :cpf, :password]
  @optional [:password_hash]

  embedded_schema do
    field :name, :string
    field :cpf, :string
    field :password, :string, redact: true
    field :password_hash, :string, redact: true
  end

  @doc false
  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_length(:cpf, min: 11, max: 11)
    |> validate_format(:cpf, ~r/[0-9]+/)
    |> validate_length(:password, min: 8)
    |> hash_password()
  end

  def hash_password(%{valid?: false} = changeset),
    do: changeset

  def hash_password(changeset) do
    password_hash =
      changeset
      |> fetch_change!(:password)
      |> Argon2.hash_pwd_salt()

    changeset
    |> put_change(:password_hash, password_hash)
  end
end
