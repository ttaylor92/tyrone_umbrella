defmodule GiphyScraperWeb.Schema.Queries.GiphyImageQuery do
  use Absinthe.Schema.Notation

  object :giphy_image_query do

    field :search_giphy_image, :gipy_image_response do
      arg :query, :string

      resolve &GiphyScraperWeb.GiphyImageResolver.search_giphy_image/3
    end
  end
end
