defmodule BankingApiWeb.UserAccountView do
  use BankingApiWeb, :view

  def render("show.json", %{account: account, user: user}) do
    %{name: user.name, cpf: user.cpf, balance: account.balance}
  end
end
