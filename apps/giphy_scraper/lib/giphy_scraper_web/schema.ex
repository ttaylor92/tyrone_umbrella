# defmodule GiphyScraperWeb.Schema do
#   use Absinthe.Schema

#   # query do

#   # end

#   # mutation do
#   # end


#   def context(context) do
#     loader =
#       Dataloader.new()
#       # |> Dataloader.add_source(User, User.data())

#     Map.put(context, :loader, loader)
#   end

#   def plugins do
#     [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
#   end

#   def middleware(middleware, _, %{identifier: identifier}) when identifier === :mutation do
#     pre_resolution_middleware() ++ middleware ++ post_resolution_middleware()
#   end

#   def middleware(middleware, _, _) do
#     middleware
#   end

#   defp pre_resolution_middleware do
#     []
#   end

#   defp post_resolution_middleware do
#     [SharedUtils.Middlewares.ChangesetConverterMiddleware]
#   end
# end
