defmodule SchemasPG.AccountManagement.User do
  use SchemasPG

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string

    has_one :preferences, SchemasPG.AccountManagement.Preference,
      on_replace: :delete

    has_one :users, SchemasPG.Giphy.GiphyImage,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @required_fields [:first_name, :last_name, :email]
  @available_fields []

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:first_name, min: 3)
    |> validate_length(:last_name, min: 3)
    |> unique_constraint(:email)
    |> cast_assoc(:preferences)
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

  def get_user_ids(offset) do
    from(u in __MODULE__, select: u.id, offset: ^offset)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(user, opts) do
      %{
        user_id: user.id,
        first_name: user.first_name
      }
      |> Jason.Encoder.Map.encode(opts)
    end
  end
end
