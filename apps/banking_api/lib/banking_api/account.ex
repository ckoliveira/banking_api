defmodule BankingApi.Account do
  alias BankingApi.Users.Schemas.User
  alias BankingApi.Accounts.Schemas.Account
  alias BankingApi.User
  alias BankingApi.Repo

  import Ecto.Query

  require Logger

  defp check_balance(user, value) do
    account = Repo.get_by(Account, user_id: user.id)

    case account.balance >= value do
      true ->
        {:ok, account}

      false ->
        {:error, :not_enough_balance}
    end
  end

  def withdraw(cpf, password, amount) do
    with {:ok, user} <- User.authenticate(cpf, password),
         {:ok, account} <- check_balance(user, amount) do
      from(acc in Account, where: acc.user_id == ^user.id)
      |> Repo.update_all(set: [balance: account.balance - amount])

      {:ok, account}
    else
      {:error, :user_not_found} = error ->
        Logger.error("user with cpf #{cpf} not found")
        error

      {:error, :invalid_password} = error ->
        Logger.error("invalid password for user with cpf #{cpf}")
        error

      {:error, :not_enough_balance} ->
        Logger.error("Not enough money in balance")
        {:error, :not_enough_balance}
    end
  end

  @doc """
  Transfer a given amount from cpf1 to cpf2
  """
  def transfer(cpf1, password, cpf2, amount) do
    with {:ok, user1} <- User.authenticate(cpf1, password),
         {:ok, user2, account2} <- User.get(cpf2),
         {:ok, account} <- check_balance(user1, amount) do
      # remove amount from user1
      from(acc in Account, where: acc.user_id == ^user1.id)
      |> Repo.update_all(set: [balance: account.balance - amount])

      # and add it to user2
      from(acc in Account, where: acc.user_id == ^user2.id)
      |> Repo.update_all(set: [balance: account2.balance + amount])

      Logger.info("#{user1.name} transfered #{amount} to #{user2.name}")
      {:ok, account, account2}
    else
      {:error, :not_enough_balance} = error ->
        Logger.error("Not enough money in balance")
        error

      {:error, :user_not_found} = error ->
        Logger.error("user not found")
        error

      {:error, :invalid_password} = error ->
        Logger.error("invalid password")
        error
    end
  end
end
