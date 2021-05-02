defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/user", BankingApiWeb do
    pipe_through :api

    post "/", UserController, :create
    get "/:cpf", UserController, :fetch
  end

  scope "/api/account", BankingApiWeb do
    pipe_through :api

    post "/withdraw", AccountController, :withdraw
    post "/transfer", AccountController, :transfer
  end
end
