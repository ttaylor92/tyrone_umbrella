defmodule SchemasPg.Giphy.GiphyImageTest do
  use SchemasPG.Support.Datacase
  import SchemasPG.Support.Datacase, only: [errors_on: 1]

  alias SchemasPG.Giphy.GiphyImage

  describe "changeset/2" do

    test "changeset is valid with required params" do
      attr = %{
        username: "random",
        url: "random",
        title: "random",
        user_id: 1
      }
      changeset = GiphyImage.create_changeset(attr)

      assert changeset.valid?
      assert changeset.changes.username === attr.username
      assert changeset.changes.url === attr.url
      assert changeset.changes.title === attr.title
    end

    test "changeset is invalid without required params" do
      changeset = GiphyImage.create_changeset(%{})

      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).user
      assert "can't be blank" in errors_on(changeset).url
      assert "can't be blank" in errors_on(changeset).title
      assert "can't be blank" in errors_on(changeset).username
    end
  end
end
