defmodule GraphqlApiAssignment.TokenCacheTest do
  use ExUnit.Case, async: true

  alias GraphqlApiAssignment.TokenCache

  test "stores and retrieves a token" do
    {:ok, pid} =
      TokenCache.start_link(
        name: :test_store_n_retrieve_tokens,
        table_name: :test_store_n_retrieve_tokens
      )

    user_id = 1
    token = "some_token"

    assert TokenCache.put(user_id, token, pid)
    assert TokenCache.get(user_id, pid) === token
  end

  test "returns a message for a non-existent token" do
    {:ok, pid} =
      TokenCache.start_link(
        name: :test_non_existent_tokens,
        table_name: :test_non_existent_tokens
      )

    assert TokenCache.get(999, pid) ===
             "Token creation is processing. Token will be distributed once processing is done."
  end

  test "deletes a token" do
    {:ok, pid} =
      TokenCache.start_link(
        name: :test_deletes_tokens,
        table_name: :test_deletes_tokens
      )

    user_id = 2
    token = "another_token"

    assert TokenCache.put(user_id, token, pid)
    assert TokenCache.get(user_id, pid) === token

    assert TokenCache.delete(user_id, pid)

    assert TokenCache.get(user_id, pid) ===
             "Token creation is processing. Token will be distributed once processing is done."
  end
end
