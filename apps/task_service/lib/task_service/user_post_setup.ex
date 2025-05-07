defmodule TaskService.UserPostSetup do
  use Oban.Worker,
    queue: :default,
    unique: [fields: [:worker, :args], keys: [:user_id], period: 60]

  require Logger

  @impl true
  def perform(%Oban.Job{args: %{"user_id" => user_id, "first_name" => first_name}}) do
    Logger.info("Fetching GIFs for user #{user_id} with query #{first_name}")

    with {:ok, result} <- GiphyScraper.GiphyImageHandlers.search(first_name) do
      Enum.map(result, fn giphy_image_struct ->
        giphy_image_struct
        |> Map.from_struct()
        |> Map.put(:user_id, user_id)
        |> SchemasPG.Giphy.create_image()
      end)
    end
  end

  def handle_user_creation(%{id: _, first_name: _} = data) do
    data
    |> Map.put(:user_id, & &1.id)
    |> new()
    |> Oban.insert()
  end
end
