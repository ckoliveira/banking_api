defmodule BankingApiWeb.UserController do

  use BankingApiWeb, :controller

  alias BankingApi.User

  def fetch(conn, %{"cpf" => cpf}) do
    case User.get(cpf) do
      {:ok, user, account} ->
        msg = %{name: user.name,
              balance: account.balance}
        send_json(conn, 200, msg)

      {:error, :user_not_found} ->
        send_json(conn, 400, %{type: "invalid input", description: "cpf #{inspect(cpf)} not found"})

      end
  end

  def create(conn, %{} = params) do
    user = %{name: params["name"], cpf: params["cpf"]}
    case User.create(user) do
      {:ok, user} -> send_json(conn, 200, user)

      {:error, %Ecto.Changeset{errors: errors}} ->
        msg = %{type: "invalid input", description: "#{inspect(errors)}"}
        send_json(conn, 400, msg)

      {:error, :duplicated_cpf} ->
        msg = %{type: "invalid input", description: "cpf already being used"}
        send_json(conn, 412, msg)
    end
  end

  defp send_json(conn, status, body) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
