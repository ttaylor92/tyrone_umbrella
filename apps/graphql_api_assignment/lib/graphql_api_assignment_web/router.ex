defmodule GraphqlApiAssignmentWeb.Router do
  use GraphqlApiAssignmentWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: GraphqlApiAssignmentWeb.Schema

    if Mix.env() === :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        interface: :playground,
        schema: GraphqlApiAssignmentWeb.Schema,
        socket: GraphqlApiAssignmentWeb.UserSocket
    end
  end
end
