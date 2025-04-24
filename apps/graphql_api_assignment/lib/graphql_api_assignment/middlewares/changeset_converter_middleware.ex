defmodule GraphqlApiAssignment.Middlewares.ChangesetConverterMiddleware do
  @behaviour Absinthe.Middleware

  alias Absinthe.Resolution
  alias Ecto.Changeset
  alias GraphqlApiAssignment.ErrorUtils

  @impl Absinthe.Middleware
  def call(%Resolution{state: :resolved, errors: []} = resolution, _config), do: resolution

  def call(%Resolution{state: :resolved, errors: errors} = resolution, _config) do
    handle_error(resolution, errors)
  end

  def call(resolution, _config), do: resolution

  defp handle_error(resolution, []), do: resolution

  defp handle_error(resolution, [%Changeset{} = head | tail]) do
    error_list = Changeset.traverse_errors(head, &translate_error/1)

    value =
      if Enum.any?(head.errors, fn {field, _} -> field === :email end) do
        if Map.get(error_list, :email) === ["has already been taken"] do
          ErrorUtils.conflict("Email Already Exists", error_list)
        else
          ErrorUtils.bad_request("Email #{List.first(Map.get(error_list, :email))}", error_list)
        end
      else
        ErrorUtils.bad_request("Unsupported request", error_list)
      end

    resolution
    |> update_resolution(value)
    |> handle_error(tail)
  end

  defp handle_error(resolution, [%ErrorMessage{} = head | tail]) do
    error_data = ErrorMessage.to_jsonable_map(head)
    resolution
    |> update_resolution(ErrorUtils.bad_request("Unsupported request", error_data))
    |> handle_error(tail)
  end

  defp handle_error(resolution, [head | tail]) when is_binary(head) === true do
    resolution
    |> update_resolution(ErrorUtils.unauthorized())
    |> handle_error(tail)
  end

  defp handle_error(resolution, [head | tail]) do
    resolution
    |> handle_unexpected_error(head)
    |> handle_error(tail)
  end

  defp handle_unexpected_error(resolution, _error) do
    update_resolution(resolution, ErrorUtils.internal_server_error())
  end

  defp update_resolution(resolution, value) do
    %Resolution{resolution | errors: [value]}
  end

  defp translate_error({message, opts}) do
    Regex.replace(~r"%{(\w+)}", message, fn _, key ->
      atom_key = String.to_existing_atom(key)
      opts |> Keyword.get(atom_key, key) |> to_string()
    end)
  end
end
