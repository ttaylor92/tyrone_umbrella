defmodule GraphqlApiAssignmentWeb.Types.BucketInputType do
  use Absinthe.Schema.Notation

  enum :bucket_action do
    value :create_user, as: "create_user"
    value :get_user, as: "get_user"
    value :get_users, as: "get_users"
    value :update_user, as: "update_user"
    value :update_user_preferences, as: "update_user_preferences"
  end
end
