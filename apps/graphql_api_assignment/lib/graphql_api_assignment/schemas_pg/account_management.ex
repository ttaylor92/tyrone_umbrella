defmodule GraphqlApiAssignment.SchemasPG.AccountManagement do
  @moduledoc """
  The Accounts context.

  This context is responsible for managing user accounts, including creation,
  retrieval, updating, and deletion of user data.
  """

  alias EctoShorts.Actions
  alias GraphqlApiAssignment.SchemasPG.AccountManagement.{User, Preference}
  alias GraphqlApiAssignment.Repo

  def create_user(params) do
    Actions.create(User, params)
  end

  def get_user(id, opts \\ []) do
    User
    |> Actions.get(id)
    |> maybe_preload(opts)
  end

  def update_user(id, params, opts \\ []) do
    case Actions.update(User, id, params) do
      {:error, error} -> {:error, error}
      {:ok, schema_data} -> maybe_preload(schema_data, opts)
    end
  end

  def delete_user(id) do
    Actions.delete(User, id)
  end

  def create_user_preference(params) do
    Actions.create(Preference, params)
  end

  def update_user_preference(id, params) do
    Actions.update(Preference, id, params)
  end

  def get_user_ids(offset \\ 0) do
    Actions.all(User.get_user_ids(offset))
  end

  def get_users(params \\ %{}) do
    preferences = params
      |> Map.get(:preferences, %{})
      |> Map.to_list()

    options = params
      |> Map.delete(:preferences)
      |> Map.keys()
      |> Enum.map(fn key -> {key, Map.get(params, key)} end)

    Actions.all(Preference.with_preferences_query(preferences), options)
  end

  defp maybe_preload(schema_data, opts) do
    case opts[:preload] do
      nil -> schema_data
      preload -> Repo.preload(schema_data, preload)
    end
  end
end
