defmodule BankingApi.Accounts.Schemas.Account do
  @moduledoc """
  TBD
  """

  use Ecto.Schema

  alias BankingApi.Users.Schemas.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    belongs_to :user, User
    field :balance, :integer

    timestamps()
  end
end
