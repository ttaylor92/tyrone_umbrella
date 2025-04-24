defmodule GraphqlApiAssignment.SchemasPG.AccountManagement.UserTest do
  use GraphqlApiAssignment.Support.Datacase
  import GraphqlApiAssignment.Support.Datacase, only: [errors_on: 1]
  alias GraphqlApiAssignment.SchemasPG.AccountManagement.User

  describe "changeset/2" do
    test "valid changeset with required fields" do
      attrs = %{name: "John Doe", email: "john.doe@example.com"}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid?
      assert changeset.changes.name === attrs.name
      assert changeset.changes.email === attrs.email
    end

    test "changeset is invalid without name" do
      attrs = %{email: "john.doe@example.com"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).name
    end

    test "changeset is invalid without email" do
      attrs = %{name: "John Doe"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).email
    end

    test "changeset is invalid with incorrect email format" do
      attrs = %{name: "John Doe", email: "invalid_email"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert "has invalid format" in errors_on(changeset).email
    end

    test "changeset downcases email" do
      attrs = %{name: "John Doe", email: "JOHN.DOE@EXAMPLE.COM"}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.changes.email === "john.doe@example.com"
    end
  end
end
