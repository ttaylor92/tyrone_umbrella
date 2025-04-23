defmodule GiphyScraper do
  @moduledoc """
  Documentation for `GiphyScraper`.
  """
  alias GiphyScraper.GiphyImage
  @api_key "e7jkU5tw2FuNtiQwVGYplbReiUs0Ufw4"

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
    case Req.get("https://api.giphy.com/v1/gifs/search?q=#{query}&api_key=#{@api_key}") do
      {:ok, response} -> serialize_giphy_data(response)
      {:error, error} -> {:error, error}
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
