defmodule GraphqlApiAssignment.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :text
      add :email, :text

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
