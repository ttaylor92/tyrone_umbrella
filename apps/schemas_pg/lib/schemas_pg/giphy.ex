defmodule SchemasPg.Giphy do
  alias EctoShorts.Actions
  alias SchemasPG.Giphy.GiphyImage

  def create_image(params) do
    Actions.create(GiphyImage, params)
  end

  def find_image(params, opts \\ []) do
    Actions.find(GiphyImage, params, opts)
  end
end
