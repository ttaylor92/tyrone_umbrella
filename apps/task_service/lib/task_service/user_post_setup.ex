defmodule TaskService.UserPostSetup do
  use Oban.Worker,
    queue: :default,
    unique: [fields: [:worker, :args], keys: [:user_id], period: 60]

  require Logger


  @impl true
  def perform(%Oban.Job{args: %{"user_id" => user_id, "first_name" => first_name}}) do
    Logger.info("Fetching GIFs for user #{user_id} with query #{first_name}")

    GiphyScraper.GiphyImageHandlers.search(first_name)
    |> Enum.map(fn giphy_image_struct ->
      Map.put(giphy_image_struct, :user_id, user_id)
    end)
    |> SchemasPG.Giphy.create_image()
  end

  def handle_user_creation(%{id: _, first_name: _} = data) do
    data
    |> Map.put(:user_id, & &1.id)
    |> new()
    |> Oban.insert()
  end
end
