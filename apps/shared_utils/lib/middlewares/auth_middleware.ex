defmodule SharedUtils.Middlewares.AuthMiddleware do
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution

  def call(%Resolution{context: %{secret_key: provided_key}} = resolution, opts) do
    expected_key = Keyword.get(opts, :secret_key, nil)

    if provided_key === expected_key do
      resolution
    else
      Resolution.put_result(resolution, {:error, "unauthorized"})
    end
  end

  def call(resolution, _opts) do
    resolution
  end
end
