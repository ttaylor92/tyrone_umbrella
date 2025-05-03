defmodule GiphyScraper.GiphyImageHandlers do
  alias GiphyScraper.GiphyImage

  @api_key "e7jkU5tw2FuNtiQwVGYplbReiUs0Ufw4"
  @chunk_amount 10

  @doc """
  Search Function to fetch query from the giphy api.

  ## Response type:
  [
    %GiphyScraper.GiphyImage{
      id: "some_id",
      url: "url_to_gif",
      username: "username of creator",
      title: "SomeGif"
    },

    %GiphyScraper.GiphyImage{
      id: "some_other_id",
      url: "url_to_gif_2",
      username: "username of creator",
      title: "MyGif"
    }
  ]

  """
  def search(query) do
    with {:ok, response} <-
           Req.get("https://api.giphy.com/v1/gifs/search?q=#{query}&api_key=#{@api_key}") do
      serialized_data = serialize_giphy_data(response)

      serialized_data
      |> Enum.chunk_every(@chunk_amount)
      |> Enum.each(fn chunk ->
        GiphyScraper.ImageProcessor.process_chunk(chunk)
      end)

      {:ok, serialized_data}
    end
  end

  defp serialize_giphy_data(%{body: %{"data" => data}}) do
    Enum.map(data, fn gif_data ->
      %GiphyImage{
        username: gif_data["username"],
        url: gif_data["url"],
        id: gif_data["id"],
        title: gif_data["title"]
      }
    end)
  end

  defp serialize_giphy_data(_) do
    {:error, "Incorrect data structure submitted for serialization"}
  end
end
