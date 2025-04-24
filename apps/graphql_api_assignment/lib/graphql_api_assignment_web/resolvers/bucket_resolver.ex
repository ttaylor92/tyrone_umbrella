defmodule GraphqlApiAssignmentWeb.Resolvers.BucketResolver do
  alias GraphqlApiAssignment.HashringCounter

  def get_resolver_hits(_, %{key: key}, _) do
    case key do
      "create_user" -> {:ok, HashringCounter.get_key_count(:create_user)}
      "get_user" -> {:ok, HashringCounter.get_key_count(:get_user)}
      "get_users" -> {:ok, HashringCounter.get_key_count(:get_users)}
      "update_user" -> {:ok, HashringCounter.get_key_count(:update_user)}
      "update_user_preferences" -> {:ok, HashringCounter.get_key_count(:update_user_preferences)}
    end
  end
end
