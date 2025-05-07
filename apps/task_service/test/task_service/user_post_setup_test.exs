defmodule TaskService.UserPostSetupTest do
  use SchemasPG.Support.Datacase

  alias SchemasPG.Support.Factory.AccountManagement.{
    PreferenceFactory,
    UserFactory
  }

  describe "&prerform/1" do
    test "" do
      Req.Test.stub(GiphyScraper.GiphyImageHandlers, fn conn ->
        Req.Test.json(conn, [
          %{
            "username" => "user",
            "url" => "https://giphy.com/1",
            "id" => "1",
            "title" => "user_image"
          },
          %{
            "username" => "user",
            "url" => "https://giphy.com/2",
            "id" => "2",
            "title" => "user_image"
          },
        ])
      end)

      user = UserFactory.insert!(%{first_name: "user"})
      preference = PreferenceFactory.insert!(%{user_id: user.id})

      assert {:ok, _} = TaskService.UserPostSetup.handle_user_creation(%{user | preferences: preference})

      Process.sleep(500)

      assert list = SchemasPG.Giphy.find_user_images(user.id)

      assert Enum.empty?(list) === false
    end
  end
end
