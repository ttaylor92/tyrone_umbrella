defmodule SchemasPG.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    rename table(:users), :name, to: :first_name

    alter table(:users) do
      add :last_name, :text, null: false
      modify :first_name, :text, null: false
    end
  end
end
