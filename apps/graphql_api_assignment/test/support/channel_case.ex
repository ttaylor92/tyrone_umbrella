defmodule GraphqlApiAssignmentWeb.Support.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      import Phoenix.ChannelTest
      import GraphqlApiAssignmentWeb.Support.ChannelCase

      # The default endpoint for test
      @endpoint GraphqlApiAssignmentWeb.Endpoint
    end
  end
end
