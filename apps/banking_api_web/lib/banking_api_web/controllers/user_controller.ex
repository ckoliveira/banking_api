defmodule BankingApiWeb.UserController do
  use BankingApiWeb, :controller

  alias BankingApi.User
  alias BankingApi.Users.Inputs.CreateUser
  alias BankingApi.ChangesetValidation

  alias BankingApiWeb.UserAccountView
  alias BankingApiWeb.UserView

  @doc """
  Creates a user.
  """
  @spec create(conn :: Plug.Conn.t(), params :: map) :: Plug.Conn.t()
  def create(conn, params) do
    with {:ok, input} <- ChangesetValidation.cast_and_apply(CreateUser, params),
         {:ok, user} <- User.create(input) do
      conn
      |> put_view(UserView)
      |> render("show.json", %{user: user})
    else
      {:error, %Ecto.Changeset{valid?: false, errors: err}} ->
        send_json(conn, 400, %{type: "invalid input", description: "#{inspect(err)}"})

      {:error, :duplicated_cpf} ->
        send_json(conn, 400, %{type: "invalid input", description: "cpf already being used"})
    end
  end

  def fetch(conn, %{"password" => password, "cpf" => cpf}) do
    with {:ok, _user} <- User.authenticate(cpf, password),
         {:ok, user, account} <- User.get(cpf) do
      conn
      |> put_view(UserAccountView)
      |> render("show.json", %{account: account, user: user})
    else
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
