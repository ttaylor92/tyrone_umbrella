defmodule GiphyScraperWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: GiphyScraperWeb.Schema

  ## Channels
  channel "graphql:*", Absinthe.Phoenix.Channel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
