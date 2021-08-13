defmodule BankingApi.Repo.Migrations.CreatePassword do
  use Ecto.Migration

  def change do
    create table(:passwords, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :password_hash, :string
      add :user_id, references(:users, type: :uuid)

      timestamps()
    end

    create unique_index(:passwords, [:user_id])
  end
end
