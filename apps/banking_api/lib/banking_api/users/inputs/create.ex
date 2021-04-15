defmodule BankingApi.Users.Inputs.Create do
  @moduledoc """
  Create, validate and insert a new user in the database
  """

  import Ecto.Changeset

  alias BankingApi.Users.Schemas.User

  @required [:name, :cpf]
  @optional []

  def changeset(params) do
    %User{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_length(:cpf, min: 11, max: 11)
  end
end
