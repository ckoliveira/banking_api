defmodule BankingApi.User do
  @moduledoc """
  Creates an User entry on the database and associates it with an Account
  """

  alias BankingApi.Passwords.Inputs.Create, as: PWDCreate
  alias BankingApi.Users.Inputs.Create
  alias BankingApi.Users.Schemas.User
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.Passwords.Schemas.Password
  alias BankingApi.Repo

  require Logger

  def authenticate(cpf, pwd) do
    with {:ok, user, _account} <- get(cpf),
         {:pwd, %{password_hash: pwd_hash}} <- {:pwd, Repo.get_by(Password, [user_id: user.id])},
         {:pwd_status, true} <- {:pwd_status, Argon2.verify_pass(pwd, pwd_hash)} do

          {:ok, user}
    else
      {:error, :user_not_found} ->
        {:error, :invalid_credentials}
      {:pwd_status, false} ->
        {:error, :invalid_credentials}
    end
  end

  def create(%{} = user) do
    Logger.info("Creating new user...")

    u = %{name: user.name, cpf: user.cpf}
    pwd = %{password: user.password}

    with %{valid?: true} = changeset <- Create.changeset(u),
         %{valid?: true} = pwd_changeset <- PWDCreate.changeset(pwd) do

        Repo.insert(changeset)
        u = Repo.get_by(User, [cpf: user.cpf])

        account = Ecto.build_assoc(u, :accounts)
        password = Ecto.build_assoc(u, :passwords, pwd_changeset.changes)

        Repo.insert(account)
        Repo.insert(password)

        Logger.info("User #{user.name} created!")
        {:ok, u}

    else
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
