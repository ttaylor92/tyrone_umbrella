defmodule SchemasPG.Giphy.GiphyImage do
  use SchemasPG

  schema "giphy_image" do
    field :username, :string
    field :url, :string
    field :title, :string

    belongs_to :users, SchemasPG.AccountManagement.User

    timestamps(@timestamps_opts)
  end

  @required_fields []
  @available_fields [:username, :email, :title]

  def changeset(giphy_image, attr) do
    giphy_image
    |> cast(attr, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end

  def create_changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end
end
