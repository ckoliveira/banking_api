defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User
  alias BankingApi.Account

  describe "test withdraws" do
    test "try to withdraw from account with enough balance" do
      user = %{
        name: "maurizio",
        cpf: "11122233345",
        password: "8ji898jdjav"
      }

      assert {:ok, _user} = User.create(user)
      assert {:ok, _account} = Account.withdraw(user.cpf, user.password, 500)
    end

    test "try to withdraw from account with not enough balance" do
      user = %{
        name: "mathias",
        cpf: "11122233345",
        password: "plae39vnz"
      }

      assert {:ok, _user} = User.create(user)
      assert {:error, :not_enough_balance} = Account.withdraw(user.cpf, user.password, 1001)
    end

    test "try to withdraw from non existent account" do
      pwd = "8h598thuhf4"
      cpf = "11122433345"
      assert {:error, :invalid_credentials} = Account.withdraw(cpf, pwd, 500)
    end
  end

  describe "test transferences" do
    setup do
      [
        cpf1: "11122233345",
        cpf2: "55544433321",
        name1: "maurizio",
        name2: "julia",
        pwd1: "7yhf9h85g8h8",
        pwd2: "nij09j48j8j92",
        user1: User.create(%{name: "maurizio", cpf: "11122233345", password: "7yhf9h85g8h8"}),
        user2: User.create(%{name: "julia", cpf: "55544433321", password: "nij09j48j8j92"})
      ]
    end

    test "try to transfer from account with enough balance", state do
      assert {:ok, _account1, _account2} =
               Account.transfer(state.cpf1, state.pwd1, state.cpf2, 100)
    end

    test "try to transfer from account with not enough balance", state do
      assert {:error, :not_enough_balance} =
               Account.transfer(state.cpf1, state.pwd1, state.cpf2, 1001)
    end

    test "try to transfer to non existent account", state do
      assert {:error, :user_not_found} =
               Account.transfer(state.cpf1, state.pwd1, "99988877700", 200)
    end

    test "try to to transfer passing wrong password", state do
      assert {:error, :invalid_credentials} =
               Account.transfer(state.cpf1, "8jun8j888jnja", state.cpf2, 200)
    end
  end
end
