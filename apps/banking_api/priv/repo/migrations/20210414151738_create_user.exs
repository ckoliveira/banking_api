defmodule BankingApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :cpf, :string

      timestamps()
    end

    create unique_index(:users, [:cpf])
  end
end
