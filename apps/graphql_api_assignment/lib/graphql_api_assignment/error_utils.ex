defmodule GraphqlApiAssignment.ErrorUtils do

  @type error_response :: %{code: term(), details: map(), message: String.t()}

  @spec not_found(String.t()) :: error_response()
  @spec not_found(String.t(), map()) :: error_response()
  def not_found(message, details \\ %{}) do
    create_error(:not_found, message, details)
  end


  @spec internal_server_error() :: error_response()
  @spec internal_server_error(String.t()) :: error_response()
  @spec internal_server_error(String.t(), map()) :: error_response()
  def internal_server_error(message \\ "Unexpected error occurred", details \\ %{}) do
    create_error(:internal_server_error, message, details)
  end


  @spec not_acceptable(String.t()) :: error_response()
  @spec not_acceptable(String.t(), map()) :: error_response()
  def not_acceptable(message, details \\ %{}) do
    create_error(:not_acceptable, message, details)
  end


  @spec conflict(String.t()) :: error_response()
  @spec conflict(String.t(), map()) :: error_response()
  def conflict(message, details \\ %{}) do
    create_error(:conflict, message, details)
  end

  @spec bad_request(String.t()) :: error_response()
  @spec bad_request(String.t(), map()) :: error_response()
  def bad_request(message, details \\ %{}) do
    create_error(:bad_request, message, details)
  end

  @spec unauthorized() :: error_response()
  def unauthorized do
    create_error(:unauthorized, "You are not allowed to access this resource.", %{})
  end

  defp create_error(code, message, details) do
    %{code: code, details: details, message: message}
  end
end
