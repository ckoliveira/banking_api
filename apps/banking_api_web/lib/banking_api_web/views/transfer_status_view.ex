defmodule BankingApiWeb.TransferStatusView do
  use BankingApiWeb, :view

  def render("show.json", %{user: user1}) do
    %{user: user1}
  end
end
