defmodule GraphqlApiAssignmentWeb.Resolvers.UserResolver do
  alias GraphqlApiAssignment.{UserService, HashringCounter, GiphyJobCreator}
  alias SchemasPG.AccountManagement.User
  alias GraphqlApiAssignment.TokenPipeline.TokenProducer

  def get_giphy_image_queries(_, _, %User{id: id}) do
    {:ok, SchemasPG.Giphy.find_user_images(id)}
  end

  def get_user_by_id(_, %{id: id}, _) do
    HashringCounter.increment_key(:get_user)
    UserService.get_user_by_id(id)
  end

  def create_user(_, args, _) do
    HashringCounter.increment_key(:create_user)

    with {:ok, user_schema_data} <- UserService.create_user(args),
         :ok <- submit_new_user_id_for_token_generation(user_schema_data),
         :ok <- GiphyJobCreator.process_user(user_schema_data) do
      {:ok, user_schema_data}
    end
  end

  def get_users_by_preferences(_, args, _) do
    HashringCounter.increment_key(:get_users)
    UserService.get_users(args)
  end

  def update_a_user(_, args, _) do
    HashringCounter.increment_key(:update_user)
    UserService.update_a_user(args)
  end

  def update_user_preference(_, args, _) do
    HashringCounter.increment_key(:update_user_preferences)
    UserService.update_user_preference(args)
  end

  def create_user_trigger_topic(_) do
    "new_user"
  end

  def create_user_subscription_config(_, _) do
    {:ok, topic: "new_user"}
  end

  def update_user_preference_topic(preference_response) do
    preference_response.user_id
  end

  def update_user_preference_subscription_config(preference_response, _) do
    {:ok, topic: preference_response.user_id}
  end

  def user_token_created_subscription_config(response, _) do
    {:ok, topic: response.user_id}
  end

  def get_user_auth_token(%{id: id}, _, _) do
    {:ok, GraphqlApiAssignment.TokenCache.get(id)}
  end

  defp submit_new_user_id_for_token_generation(user) do
    TokenProducer.new_user_registered(user.id)
  end
end
