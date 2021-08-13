defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/user", BankingApiWeb do
    pipe_through :api

    post "/", UserController, :create
    get "/fetch", UserController, :fetch
  end

  scope "/api/account", BankingApiWeb do
    pipe_through :api

    patch "/withdraw", AccountsController, :withdraw
    patch "/transfer", AccountsController, :transfer
  end
end
