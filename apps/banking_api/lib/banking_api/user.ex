defmodule BankingApi.User do
  @moduledoc """
  Creates a User entry on the database and associates it with an Account and a Password.
  """

  alias BankingApi.Users.Schemas.User
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Passwords.Schemas.Password
  alias BankingApi.Repo

  require Logger

  def authenticate(cpf, pwd) do
    with {:ok, user, _account} <- get(cpf),
         {:password, %{password_hash: pwd_hash}} <-
           {:password, Repo.get_by(Password, user_id: user.id)},
         {:authenticated?, true} <- {:authenticated?, Argon2.verify_pass(pwd, pwd_hash)} do
      {:ok, user}
    else
      {:authenticated?, false} ->
        {:error, :invalid_password}

      {:error, :user_not_found} ->
        {:error, :user_not_found}
    end
  end

  def create(%{} = input) do
    Logger.info("Creating new user...")

    user = %{name: input.name, cpf: input.cpf}
    password = %{password_hash: input.password_hash}

    with %{valid?: true} = changeset <- User.changeset(user),
         %{valid?: true} = pwd_changeset <- Password.changeset(password) do
      Repo.insert(changeset)
      u = Repo.get_by(User, cpf: user.cpf)

      account = Ecto.build_assoc(u, :accounts)
      password = Ecto.build_assoc(u, :passwords, pwd_changeset.changes)

      Repo.insert(account)
      Repo.insert(password)

      Logger.info("User #{user.name} created!")
      {:ok, u}
    else
      %{valid?: false} = changeset ->
        %{errors: errors} = changeset
        Logger.error("Error while trying to create new user: #{inspect(errors)}")
        {:error, changeset}
    end
  rescue
    Ecto.ConstraintError ->
      Logger.info("CPF already being used")
      {:error, :duplicated_cpf}
  end

  def get(cpf) do
    Logger.info("Tryin to get a user and balance info using a CPF")

    case Repo.get_by(User, cpf: cpf) do
      nil ->
        {:error, :user_not_found}

      user ->
        acc = Repo.get_by(Account, user_id: user.id)
        {:ok, user, acc}
    end
  end
end
