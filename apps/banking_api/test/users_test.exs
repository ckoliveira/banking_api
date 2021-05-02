defmodule BankingApi.UsersTest do
  use BankingApi.DataCase, async: true

  alias BankingApi.User

  test "create new user with valid input" do
    u = %{
      name: "ricardo villalobos",
      cpf: "56776589323",
      password: "57hvj95g9j9"
    }

    assert {:ok, _user} = User.create(u)
  end

  test "fail when trying to create a new user with a cpf thats already being used" do
    u = %{
      name: "tom jenkinson",
      cpf: "32189056790",
      password: "8459j5gj858"
    }

    assert {:ok, _user} = User.create(u)
    assert {:error, :duplicated_cpf} = User.create(u)
  end

  test "fail when trying to create user with invalid input" do
    u = %{
      name: "ab",
      cpf: "00902",
      password: "8u"
    }

    assert {:error, %{errors: _error}} = User.create(u)
  end

  test "fetch an user from database with an already registered cpf" do
    u = %{
      name: "richard d james",
      cpf: "11122233345",
      password: "85nks94injf1"
    }

    assert {:ok, _user} = User.create(u)
    assert {:ok, _user, _acc} = User.get(u.cpf)
  end

  test "fetch an user from database with a not yet registered cpf" do
    cpf = "44455566689"

    assert {:error, :user_not_found} = User.get(cpf)
  end
end
