defmodule GraphqlApiAssignmentWeb.Types.UserInputType do
  use Absinthe.Schema.Notation

  input_object :preference_input do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
    field :likes_faxes, :boolean
  end
end
