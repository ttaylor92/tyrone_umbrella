defmodule SharedUtils.ErrorUtilsTest do
  use ExUnit.Case
  alias SharedUtils.ErrorUtils

  test "not_found/2 returns the correct error structure" do
    expected = %{code: :not_found, message: "Resource not found", details: %{}}
    assert ErrorUtils.not_found("Resource not found") === expected
  end

  test "internal_server_error/2 returns the correct error structure" do
    expected = %{code: :internal_server_error, message: "An internal error occurred", details: %{}}
    assert ErrorUtils.internal_server_error("An internal error occurred") === expected
  end

  test "not_acceptable/2 returns the correct error structure" do
    expected = %{code: :not_acceptable, message: "Not acceptable", details: %{}}
    assert ErrorUtils.not_acceptable("Not acceptable") === expected
  end

  test "conflict/2 returns the correct error structure" do
    expected = %{code: :conflict, message: "Conflict occurred", details: %{}}
    assert ErrorUtils.conflict("Conflict occurred") === expected
  end

  test "not_found/3 returns the correct error structure with details" do
    expected = %{code: :not_found, message: "Resource not found", details: "Additional details"}
    assert ErrorUtils.not_found("Resource not found", "Additional details") === expected
  end
end
