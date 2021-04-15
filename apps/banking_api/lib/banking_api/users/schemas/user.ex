defmodule BankingApi.Users.Schemas.User do
  @moduledoc """
  An User representation

  each user can only have one account and each account belongs to only one user
  """

  use Ecto.Schema

  alias BankingApi.Accounts.Schemas.Account

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :name, :string
    field :cpf, :string
    has_one :accounts, Account

    timestamps()
  end
end
