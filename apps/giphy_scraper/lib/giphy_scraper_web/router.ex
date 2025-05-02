defmodule GiphyScraperWeb.Router do
  # use GiphyScraperWeb, :router

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # scope "/api" do
  #   pipe_through :api

  #   forward "/graphql", Absinthe.Plug, schema: GiphyScraperWeb.Schema

  #   if Mix.env() === :dev do
  #     forward "/graphiql", Absinthe.Plug.GraphiQL,
  #       interface: :playground,
  #       schema: GiphyScraperWeb.Schema,
  #       socket: GiphyScraperWeb.UserSocket
  #   end
  # end
end
