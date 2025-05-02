defmodule SchemasPG.Repo.Migrations.AddGiphyImagesTable do
  use Ecto.Migration

  def change do
    create table(:giphy_images) do
      add :username, :text, null: false
      add :url, :text, null: false
      add :title, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:giphy_images, [:user_id])
  end
end
