defmodule BankingApi.User do
  @moduledoc """
  Creates an User entry on the database and associates it with an Account
  """

  alias BankingApi.Users.Inputs.Create
  alias BankingApi.Users.Schemas.User
  alias BankingApi.Repo

  require Logger

  def create(%{} = user) do
    Logger.info("Creating new user...")

    with %{valid?: true} = changeset  <- Create.changeset(user) do
      Repo.insert(changeset)
      u = Repo.get_by(User, [cpf: user.cpf])
      account = Ecto.build_assoc(u, :accounts)
      Repo.insert(account)
      Logger.info("User #{user.name} created!")
    else
      %{valid?: false} = changeset ->
        %{errors: errors} = changeset
        Logger.info("Error while trying to create new user: #{inspect(errors)}")
    end

  rescue
    Ecto.ConstraintError ->
      Logger.info("CPF already being used")
  end
end
