defmodule GiphyScraperWeb.Schema do
  use Absinthe.Schema

  alias GiphyScraperWeb.Types
  alias GiphyScraperWeb.Schema.Queries
  alias SchemasPG.Giphy.GiphyImage

  import_types Types.GiphyType
  import_types Queries.GiphyImageQuery

  query do
    import_fields :giphy_image_query
  end


  def context(context) do
    loader = Dataloader.add_source(Dataloader.new(), GiphyImage, GiphyImage.data())

    Map.put(context, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  def middleware(middleware, _, %{identifier: identifier}) when identifier === :mutation do
    pre_resolution_middleware() ++ middleware ++ post_resolution_middleware()
  end

  def middleware(middleware, _, _) do
    middleware
  end

  defp pre_resolution_middleware do
    []
  end

  defp post_resolution_middleware do
    [SharedUtils.Middlewares.ChangesetConverterMiddleware]
  end
end
