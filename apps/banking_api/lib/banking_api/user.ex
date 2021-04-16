defmodule BankingApi.User do
  @moduledoc """
  Creates an User entry on the database and associates it with an Account
  """

  alias BankingApi.Users.Inputs.Create
  alias BankingApi.Users.Schemas.User
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Repo

  require Logger

  def create(%{} = user) do
    Logger.info("Creating new user...")

    case Create.changeset(user) do
      %{valid?: true} = changeset ->
        Repo.insert(changeset)
        u = Repo.get_by(User, [cpf: user.cpf])

        account = Ecto.build_assoc(u, :accounts)

        Repo.insert(account)

        Logger.info("User #{user.name} created!")
        {:ok, user}

      %{valid?: false} = changeset ->
        %{errors: errors} = changeset
        Logger.info("Error while trying to create new user: #{inspect(errors)}")
        {:error, changeset}
    end

  rescue
    Ecto.ConstraintError ->
      Logger.info("CPF already being used")
      {:error, :duplicated_cpf}
  end

  def get(cpf) do
    Logger.info("Try to get an user and balance info using a CPF")

    case Repo.get_by(User, [cpf: cpf]) do
      nil ->
        {:error, :user_not_found}
      user ->
        acc = Repo.get_by(Account, [user_id: user.id])
        {:ok, user, acc}
    end
  end

end
