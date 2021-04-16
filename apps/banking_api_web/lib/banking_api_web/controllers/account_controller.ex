defmodule BankingApiWeb.AccountController do

  use BankingApiWeb, :controller

  alias BankingApi.Account
  alias BankingApi.User

  def withdraw(conn, %{} = params) do
    case Account.withdraw(params["cpf"], params["amount"]) do
      {:ok, _account} ->
        {:ok, user, _} = User.get(params["cpf"])
        send_json(conn, 200, "#{user.name} withdrew #{params["amount"]} from their account")

      {:error, :not_enough_balance} ->
        send_json(conn, 400, %{type: "balance error", description: "not enough money in balance"})

      {:error, :user_not_found} ->
        send_json(conn, 400, %{type: "user error", description: "user not found"})
    end
  end

  def transfer(conn, %{} = params) do
    case Account.transfer(params["cpf1"], params["cpf2"], params["amount"]) do
      {:ok, _acc1, _acc2} ->
        {:ok, user1, _} = User.get(params["cpf1"])
        {:ok, user2, _} = User.get(params["cpf2"])
        send_json(conn, 200, "#{user1.name} transfered #{params["amount"]} to #{user2.name}")

      {:error, :not_enough_balance} ->
        send_json(conn, 400, %{type: "balance error", description: "not enough money in balance"})

      {:error, :user_not_found} ->
        send_json(conn, 400, %{type: "user error", description: "user not found"})
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
