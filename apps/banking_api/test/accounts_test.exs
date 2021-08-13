defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User
  alias BankingApi.Account

  describe "test withdraws" do
    setup do
      password = "8ji898jdjav"

      params = %{
        name: "user",
        cpf: "12332112331",
        password_hash: Argon2.hash_pwd_salt(password)
      }

      user = User.create(params)

      {:ok, params: params, user: user, password: password}
    end

    test "try to withdraw from account with enough balance", ctx do
      params = ctx.params
      assert {:ok, _account} = Account.withdraw(params.cpf, ctx.password, 500)
    end

    test "try to withdraw from account with not enough balance", ctx do
      params = ctx.params
      assert {:error, :not_enough_balance} = Account.withdraw(params.cpf, ctx.password, 1001)
    end

    test "try to withdraw from non existent account" do
      pwd = "8h598thuhf4"
      cpf = "11122433345"
      assert {:error, :user_not_found} = Account.withdraw(cpf, pwd, 500)
    end
  end

  describe "test transferences" do
    setup do
      pwd1 = "7yhf9h85g8h8"
      pwd2 = "nij09j48j8j92"

      params1 = %{
        cpf: "11122233345",
        name: "maurizio",
        password_hash: Argon2.hash_pwd_salt(pwd1)
      }

      params2 = %{
        cpf: "55544433321",
        name: "julia",
        password_hash: Argon2.hash_pwd_salt(pwd2)
      }

      User.create(params1)
      User.create(params2)

      {:ok, params1: params1, params2: params2, pwd1: pwd1, pwd2: pwd2}
    end

    test "try to transfer from account with enough balance", ctx do
      params1 = ctx.params1
      params2 = ctx.params2

      assert {:ok, _account1, _account2} =
               Account.transfer(params1.cpf, ctx.pwd1, params2.cpf, 100)
    end

    test "try to transfer from account with not enough balance", ctx do
      params1 = ctx.params1
      params2 = ctx.params2

      assert {:error, :not_enough_balance} =
               Account.transfer(params1.cpf, ctx.pwd1, params2.cpf, 1001)
    end

    test "try to transfer to non existent account", ctx do
      params1 = ctx.params1

      assert {:error, :user_not_found} =
               Account.transfer(params1.cpf, ctx.pwd1, "99988877700", 200)
    end

    test "try to to transfer passing wrong password", ctx do
      params1 = ctx.params1
      params2 = ctx.params2

      assert {:error, :invalid_password} =
               Account.transfer(params1.cpf, "wrong password", params2.cpf, 200)
    end
  end
end
