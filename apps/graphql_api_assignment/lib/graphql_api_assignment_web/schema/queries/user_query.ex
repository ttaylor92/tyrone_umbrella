defmodule GraphqlApiAssignmentWeb.Schema.Queries.UserQuery do
  use Absinthe.Schema.Notation

  alias GraphqlApiAssignmentWeb.Resolvers.UserResolver

  object :user_queries do
    @desc "Get a user by ID"
    field :user, :user_response do
      arg :id, non_null(:integer)

      middleware RequestCache.Middleware, ttl: :timer.seconds(60)

      resolve &UserResolver.get_user_by_id/3
    end

    @desc "Get users by preferences"
    field :users, list_of(:user_response) do
      arg :before, :integer
      arg :after, :integer
      arg :first, :integer
      arg :preferences, :preference_input

      middleware RequestCache.Middleware, ttl: :timer.seconds(60)

      resolve &UserResolver.get_users_by_preferences/3
    end
  end
end
