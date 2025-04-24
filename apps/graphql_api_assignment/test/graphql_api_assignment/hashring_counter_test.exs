defmodule GraphqlApiAssignment.HashringCounterTest do
  use ExUnit.Case, async: true

  alias GraphqlApiAssignment.HashringCounter

  describe "incrementing user action counts" do
    test "increments create_user count" do
      assert HashringCounter.get_key_count(:create_user) === 0
      assert HashringCounter.increment_key(:create_user) === :ok
        # Delay for 1 second
      Process.sleep(1000)

      assert HashringCounter.get_key_count(:create_user) === 1
    end

    test "increments update_user count" do
      assert HashringCounter.get_key_count(:update_user) === 0
      assert HashringCounter.increment_key(:update_user) === :ok
        # Delay for 1 second
      Process.sleep(1000)

      assert HashringCounter.get_key_count(:update_user) === 1
    end

    test "increments update_user_preferences count" do
      assert HashringCounter.get_key_count(:update_user_preferences) === 0
      assert HashringCounter.increment_key(:update_user_preferences) === :ok
        # Delay for 1 second
      Process.sleep(1000)

      assert HashringCounter.get_key_count(:update_user_preferences) === 1
    end

    test "increments get_user count" do
      assert HashringCounter.get_key_count(:get_user) === 0
      assert HashringCounter.increment_key(:get_user) === :ok
        # Delay for 1 second
      Process.sleep(1000)

      assert HashringCounter.get_key_count(:get_user) === 1
    end

    test "increments get_users count" do
      assert HashringCounter.get_key_count(:get_users) === 0
      assert HashringCounter.increment_key(:get_users) === :ok
        # Delay for 1 second
      Process.sleep(1000)

      assert HashringCounter.get_key_count(:get_users) === 1
    end
  end
end
