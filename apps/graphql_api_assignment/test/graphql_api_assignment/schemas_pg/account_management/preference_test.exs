defmodule GraphqlApiAssignment.SchemasPG.AccountManagement.PreferenceTest do
  use GraphqlApiAssignment.Support.Datacase

  alias GraphqlApiAssignment.SchemasPG.AccountManagement.Preference

  describe "changeset/2" do
    test "valid changeset with all available fields" do
      attrs = %{likes_emails: true, likes_phone_calls: false, likes_faxes: true}
      changeset = Preference.changeset(%Preference{}, attrs)

      assert changeset.valid?
      refute changeset.changes["likes_phone_calls"]
      assert changeset.changes.likes_emails === true
      assert changeset.changes.likes_faxes === true
    end

    test "changeset is valid with no attributes" do
      changeset = Preference.changeset(%Preference{}, %{})

      refute changeset.changes["likes_emails"]
      refute changeset.changes["likes_phone_calls"]
      refute changeset.changes["likes_faxes"]
      assert changeset.valid?
      assert changeset.action === nil
      assert Enum.empty?(changeset.errors)
    end

    test "changeset is invalid with unexpected fields" do
      attrs = %{likes_emails: true, unexpected_field: "value"}
      changeset = Preference.changeset(%Preference{}, attrs)

      assert changeset.valid?
      refute Map.has_key?(changeset.changes, :unexpected_field)
    end

    test "changeset handles boolean defaults correctly" do
      attrs = %{likes_emails: nil, likes_phone_calls: nil, likes_faxes: nil}
      changeset = Preference.changeset(%Preference{}, attrs)

      refute changeset.changes["likes_emails"]
      refute changeset.changes["likes_phone_calls"]
      refute changeset.changes["likes_faxes"]
      assert assert changeset.valid?
      assert changeset.action === nil
      assert Enum.empty?(changeset.errors)
    end
  end
end
