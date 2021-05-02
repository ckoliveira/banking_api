# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankingApi.Repo.insert!(%BankingApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule BankingApi.Seeds do
  alias BankingApi.User

  User.create(%{
  name: "Fernanda Santos",
  cpf: "11111111124",
  password: "ad67ffg87d9"
  })

  User.create(%{
    name: "Ricardo Villalobos",
    cpf: "11111111123",
    password: "4f45t8fni"
  })

  User.create(%{
    name: "Tom Jenkinson",
    cpf: "11111111125",
    password: "v48sib9d0"
  })

  User.create(%{
    name: "Richard D James",
    cpf: "11111111126",
    password: "5gh8g994n"
  })



end
