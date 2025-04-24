defmodule GraphqlApiAssignment.RedixPoolTest do
  use ExUnit.Case, async: true
  alias GraphqlApiAssignment.RedixPool

  setup do
    # Clean up any test keys before each test
    :poolboy.transaction(:redix_pool, fn pid ->
      Redix.command(pid, ["FLUSHDB"])
    end)
    :ok
  end

  describe "put/get operations" do
    test "successfully stores and retrieves string value" do
      assert :ok = RedixPool.put("test_key", "test_value")
      assert {:ok, "test_value"} = RedixPool.get("test_key")
    end

    test "handles complex data types" do
      complex_value = %{a: 1, b: [1, 2, 3], c: "test"}
      assert :ok = RedixPool.put("complex_key", complex_value)
      assert {:ok, ^complex_value} = RedixPool.get("complex_key")
    end

    test "returns nil for non-existent key" do
      assert {:ok, nil} = RedixPool.get("non_existent_key")
    end
  end

  describe "TTL functionality" do
    test "value expires after TTL" do
      assert :ok = RedixPool.put("ttl_key", 1, "will_expire")
      assert {:ok, "will_expire"} = RedixPool.get("ttl_key")

      # Wait for expiration
      Process.sleep(1100)
      assert {:ok, nil} = RedixPool.get("ttl_key")
    end

    test "value persists without TTL" do
      assert :ok = RedixPool.put("persistent_key", "will_stay")
      Process.sleep(1100)
      assert {:ok, "will_stay"} = RedixPool.get("persistent_key")
    end
  end

  describe "concurrent operations" do
    test "handles multiple concurrent puts and gets" do
      tasks = for i <- 1..10 do
        Task.async(fn ->
          key = "key_#{i}"
          value = "value_#{i}"
          assert :ok = RedixPool.put(key, value)
          assert {:ok, return_value} = RedixPool.get(key)
          assert value === return_value
        end)
      end

      Enum.each(tasks, &Task.await/1)
    end
  end
end
