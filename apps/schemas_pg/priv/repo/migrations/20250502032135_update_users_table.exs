defmodule SchemasPG.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      rename :name, to: :first_name
      add :last_name, :text, null: false
      modify :first_name, :text, null: false
    end
  end
end
