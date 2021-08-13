defmodule BankingApi.UsersTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User
  alias BankingApi.Users.Schemas.User, as: UserSchema

  describe "create/1" do
    setup do
      user = %{
        name: "user",
        cpf: "11122233344",
        password_hash: Argon2.hash_pwd_salt("844j4fj8nasd")
      }

      {:ok, user: user}
    end

    test "creates new user with valid input", %{user: user} do
      assert {:ok, _user} = User.create(user)
    end

    test "fails when trying to create a new user with a cpf thats already being used", %{
      user: user
    } do
      assert {:ok, _user} = User.create(user)
      assert {:error, :duplicated_cpf} = User.create(user)
    end

    test "fails when trying to create user with invalid input" do
      u = %{
        name: "ab",
        cpf: "00902",
        password_hash: Argon2.hash_pwd_salt("8u")
      }

      assert {:error, %{errors: _error}} = User.create(u)
    end
  end

  describe "get/1" do
    setup do
      {:ok, user} =
        User.create(%{
          name: "richard d james",
          cpf: "11122233345",
          password_hash: Argon2.hash_pwd_salt("85nks94injf1")
        })

      {:ok, user: user}
    end

    test "sucessfully fetches a user from database", %{user: user} do
      assert {:ok, _user, _acc} = User.get(user.cpf)
    end

    test "fails when fetching a user from database with a not yet registered cpf" do
      cpf = "44455566689"

      assert {:error, :user_not_found} = User.get(cpf)
    end
  end
end
