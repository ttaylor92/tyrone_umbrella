defmodule GraphqlApiAssignment.SchemasPG.AccountManagement.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "users" do
    field :name, :string
    field :email, :string

    has_one :preferences, GraphqlApiAssignment.SchemasPG.AccountManagement.Preference,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @required_fields [:name, :email]
  @available_fields []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:name, min: 3)
    |> unique_constraint(:email)
    |> cast_assoc(:preferences)
  end

  def create_changeset(params \\ %{}) do
    changeset(%__MODULE__{}, params)
  end

  def data do
    Dataloader.Ecto.new(GraphqlApiAssignment.Repo, query: &query/2)
  end

  def query(queryable, _params) do
    queryable
  end

  def get_user_ids(offset) do
    from(u in __MODULE__, select: u.id, offset: ^offset)
  end
end
