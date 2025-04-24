defmodule GraphqlApiAssignmentWeb.Types.UserResponseType do
  alias GraphqlApiAssignmentWeb.Resolvers.UserResolver
  use Absinthe.Schema.Notation

  object :user_response do
    field :id, :integer
    field :name, :string
    field :email, :string
    field :preferences, :preference_response

    field :auth_token, :string do
      middleware RequestCache.Middleware, ttl: :timer.seconds(60)

      resolve &UserResolver.get_user_auth_token/3
    end
  end

  object :preference_response do
    field :user_id, :integer
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end
end
