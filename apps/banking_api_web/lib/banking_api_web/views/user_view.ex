defmodule BankingApiWeb.UserView do
  use BankingApiWeb, :view

  alias BankingApi.Users.Schemas.User

  def render("show.json", %{user: user}) do
    %{name: user.name, cpf: user.cpf}
  end
end
