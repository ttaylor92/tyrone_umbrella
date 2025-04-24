defmodule GraphqlApiAssignmentWeb.Schema.Queries.BucketQueryTest do
  use GraphqlApiAssignment.Support.Datacase

  alias GraphqlApiAssignment.HashringCounter
  alias GraphqlApiAssignmentWeb.Schema

  @resolver_hits_query """
    query($key: BucketAction) {
      resolverHits(key: $key)
    }
  """

  describe "@ResolverHits" do

    test "get_user returns amount of incremented hits" do
      variables = %{"key" => "GET_USER"}

      assert {:ok, %{data: %{"resolverHits" => starting_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)

      # Simulate fetching a user
      HashringCounter.increment_key(:get_user)

      new_amount = starting_amount + 1
      assert {:ok, %{data: %{"resolverHits" => ^new_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)
    end

    test "get_users returns amount of incremented hits" do
      variables = %{"key" => "GET_USERS"}

      assert {:ok, %{data: %{"resolverHits" => starting_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)

      # Simulate fetching users
      HashringCounter.increment_key(:get_users)

      new_amount = starting_amount + 1
      assert {:ok, %{data: %{"resolverHits" => ^new_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)
    end

    test "create_user returns amount of incremented hits" do
      variables = %{"key" => "CREATE_USER"}

      assert {:ok, %{data: %{"resolverHits" => starting_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)

      # Simulate creating a user
      HashringCounter.increment_key(:create_user)

      new_amount = starting_amount + 1
      assert {:ok, %{data: %{"resolverHits" => ^new_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)
    end

    test "update_user_preferences returns amount of incremented hits" do
      variables = %{"key" => "UPDATE_USER_PREFERENCES"}

      assert {:ok, %{data: %{"resolverHits" => starting_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)

      # Simulate updating user preferences
      HashringCounter.increment_key(:update_user_preferences)

      new_amount = starting_amount + 1
      assert {:ok, %{data: %{"resolverHits" => ^new_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)
    end

    test "update_user returns amount of incremented hits" do
      variables = %{"key" => "UPDATE_USER"}

      assert {:ok, %{data: %{"resolverHits" => starting_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)

      # Simulate updating user
      HashringCounter.increment_key(:update_user)

      new_amount = starting_amount + 1
      assert {:ok, %{data: %{"resolverHits" => ^new_amount}}} =
        Absinthe.run(@resolver_hits_query, Schema, variables: variables)
    end
  end
end
