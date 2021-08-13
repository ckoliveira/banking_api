defmodule BankingApi.Seeds do
  alias BankingApi.User

  users = [
    %{
      name: "Fernanda Santos",
      cpf: "11111111124",
      password: "ad67ffg87d9"
    },
    %{
      name: "Ricardo Villalobos",
      cpf: "11111111123",
      password: "4f45t8fni"
    },
    %{
      name: "Tom Jenkinson",
      cpf: "11111111125",
      password: "v48sib9d0"
    },
    %{
      name: "Richard D James",
      cpf: "11111111126",
      password: "5gh8g994n"
    }
  ]

  Enum.map(users, fn %{name: name, cpf: cpf, password: password} ->
    password_hash = Argon2.hash_pwd_salt(password)
    User.create(%{name: name, cpf: cpf, password_hash: password_hash})
  end)
end
