defmodule BankingApi.Passwords.Schemas.Password do
  use BankingApi.Schema
  alias BankingApi.Users.Schemas.User

  schema "passwords" do
    field :password_hash, :string, redact: true
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(params) when is_map(params),
    do: changeset(%__MODULE__{}, params)

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, [:password_hash])
    |> validate_required(:password_hash)
  end
end
