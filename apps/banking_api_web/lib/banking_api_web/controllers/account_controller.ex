defmodule BankingApiWeb.AccountsController do
  use BankingApiWeb, :controller

  alias BankingApi.Account
  alias BankingApi.User

  alias BankingApiWeb.TransferStatusView

  @doc """
  Withdraws money from account.
  Needs authentication.
  """
  @spec withdraw(conn :: Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  def withdraw(conn, %{} = params) do
    case Account.withdraw(params["cpf"], params["password"], String.to_integer(params["amount"])) do
      {:ok, _account} ->
        send_json(conn, 200, %{transfered_value: params["amount"]})

      {:error, :not_enough_balance} ->
        send_json(conn, 400, %{
          type: "balance error",
          description: "not enough money in balance"
        })

      {:error, error} when error in [:user_not_found, :invalid_password] ->
        send_json(conn, 412, %{
          type: "credential error",
          description: "invalid cpf and/or password"
        })
    end
  end

  @doc """
  Tranfers money from one account to another.
  The owner of the account transfering the money needs to be authenticated.
  """
  @spec transfer(conn :: Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  def transfer(conn, %{} = params) do
    case Account.transfer(
           params["cpf1"],
           params["password"],
           params["cpf2"],
           String.to_integer(params["amount"])
         ) do
      {:ok, acc, _acc2} ->
        {:ok, user, _} = User.get(params["cpf1"])

        conn
        |> put_view(TransferStatusView)
        |> render("show.json", %{user: user, account: acc})

      {:error, :not_enough_balance} ->
        send_json(conn, 400, %{type: "balance error", description: "not enough money in balance"})

      {:error, error} when error in [:user_not_found, :invalid_password] ->
        send_json(conn, 412, %{
          type: "credential error",
          description: "invalid cpf and/or password"
        })
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
