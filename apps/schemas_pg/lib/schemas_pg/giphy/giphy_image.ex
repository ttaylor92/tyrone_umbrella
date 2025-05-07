defmodule SchemasPG.Giphy.GiphyImage do
  use SchemasPG

  schema "giphy_images" do
    field :username, :string
    field :url, :string
    field :title, :string

    belongs_to :user, SchemasPG.AccountManagement.User

    timestamps(@timestamps_opts)
  end

  @required_fields [:username, :url, :title]
  @available_fields [:user_id]

  def changeset(giphy_image, attr) do
    giphy_image
    |> cast(attr, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:user_id)
    |> EctoShorts.CommonChanges.preload_change_assoc(:user, required_when_missing: :user_id)
  end

  def create_changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def data do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end
end
