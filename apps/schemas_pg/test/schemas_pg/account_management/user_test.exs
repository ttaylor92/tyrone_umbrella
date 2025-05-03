defmodule SchemasPG.AccountManagement.UserTest do
  use SchemasPG.Support.Datacase
  import SchemasPG.Support.Datacase, only: [errors_on: 1]
  alias SchemasPG.AccountManagement.User

  describe "changeset/2" do
    test "valid changeset with required fields" do
      attrs = %{first_name: "John", last_name: "Doe", email: "john.doe@example.com"}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid?
      assert changeset.changes.first_name === attrs.first_name
      assert changeset.changes.last_name === attrs.last_name
      assert changeset.changes.email === attrs.email
    end

    test "changeset is invalid without name" do
      attrs = %{email: "john.doe@example.com"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).first_name
      assert "can't be blank" in errors_on(changeset).last_name
    end

    test "changeset is invalid without email" do
      attrs = %{first_name: "John", last_name: "Doe"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).email
    end

    test "changeset is invalid with incorrect email format" do
      attrs = %{first_name: "John", last_name: "Doe", email: "invalid_email"}
      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?
      assert "has invalid format" in errors_on(changeset).email
    end

    test "changeset downcases email" do
      attrs = %{first_name: "John", last_name: "Doe", email: "JOHN.DOE@EXAMPLE.COM"}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.changes.email === "john.doe@example.com"
    end
  end
end
