defmodule GraphqlApiAssignmentWeb.Types.GiphyType do
  use Absinthe.Schema.Notation

  object :gipy_image_response do
    field :username, :string
    field :url, :string
    field :title, :string
  end

end
