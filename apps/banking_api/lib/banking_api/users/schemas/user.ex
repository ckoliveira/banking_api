defmodule BankingApi.Users.Schemas.User do
  @moduledoc """
  A User representation.

  Each user can only have one account and each account belongs to only one user.
  """

  use BankingApi.Schema

  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Passwords.Schemas.Password

  @required [:name, :cpf]
  @optional []

  schema "users" do
    field :name, :string
    field :cpf, :string
    has_one :accounts, Account
    has_one :passwords, Password

    timestamps()
  end

  def changeset(params) when is_map(params), do: changeset(%__MODULE__{}, params)

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_length(:cpf, min: 11, max: 11)
    |> validate_format(:cpf, ~r/[0-9]+/)
  end
end
