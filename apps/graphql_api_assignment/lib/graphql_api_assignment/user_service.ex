defmodule GraphqlApiAssignment.UserService do
  alias GraphqlApiAssignment.TokenPipeline.TokenProducer
  alias GraphqlApiAssignment.SchemasPG.AccountManagement

  def get_user_by_id(id) do
    case AccountManagement.get_user(id, preload: :preferences) do
      nil -> {:error, message: "User not found"}
      user -> {:ok, user}
    end
  end

  def create_user(args) do
    args
    |> AccountManagement.create_user()
    |> submit_new_user_id_for_token_generation()
  end

  def submit_new_user_id_for_token_generation({:error, changeset}) do
    {:error, changeset}
  end

  def submit_new_user_id_for_token_generation({:ok, user}) do
    TokenProducer.new_user_registered(user.id)
    {:ok, user}
  end

  def get_users(args) do
    {:ok, AccountManagement.get_users(args)}
  end

  def update_a_user(args) do
    case AccountManagement.update_user(args.id, args, preload: :preferences) do
      {:error, changeset} -> {:error, changeset}
      user -> {:ok, user}
    end
  end

  def update_user_preference(args) do
    case get_user_by_id(args.user_id) do
      {:ok, user} ->
        preference_id = user.preferences.id
        AccountManagement.update_user_preference(preference_id, args)

      {:error, message} ->
        {:error, message}
    end
  end

  def changeset_to_error(changeset) do
    {:error, message: changeset.message}
  end

  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        atom_key = String.to_existing_atom(key)
        opts |> Keyword.get(atom_key, key) |> to_string()
      end)
    end)
  end
end
