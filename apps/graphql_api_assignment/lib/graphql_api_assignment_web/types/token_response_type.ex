defmodule GraphqlApiAssignmentWeb.Types.TokenResponseType do
  use Absinthe.Schema.Notation

  object :token_response do
    field :user_id, :id
    field :token, :string
  end
end
