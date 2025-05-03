defmodule GiphyScraperWeb.GiphyImageResolver do

  def search_giphy_image(_, %{query: query}, _) do
    GiphyScraper.GiphyImageHandlers.search(query)
  end
end
