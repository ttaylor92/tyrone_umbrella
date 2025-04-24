defmodule GraphqlApiAssignmentWeb.Schema.Subscriptions.UserSubscription do
  use Absinthe.Schema.Notation

  alias GraphqlApiAssignmentWeb.Resolvers.UserResolver

  object :user_subscriptions do
    @desc "Subscribe to successful user creations"
    field :created_user, :user_response do
      trigger :create_user, topic: &UserResolver.create_user_trigger_topic/1

      config &UserResolver.create_user_subscription_config/2
    end

    @desc "Subscribe to User Preferences updates"
    field :updated_user_preferences, :preference_response do
      arg :user_id, non_null(:integer)

      trigger :update_user_preferences, topic: &UserResolver.update_user_preference_topic/1

      config &UserResolver.update_user_preference_subscription_config/2
    end

    @desc "Subscribe to User Token updates"
    field :user_auth_token, :string do
      arg :user_id, non_null(:string)

      config &UserResolver.user_token_created_subscription_config/2
    end
  end
end
