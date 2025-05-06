defmodule SchemasPG.Support.Factory.AccountManagement.UserFactory do
  @behaviour FactoryEx

  @schema SchemasPG.AccountManagement.User
  @repo SchemasPG.Repo

  def schema, do: @schema

  def repo, do: @repo

  def build(params \\ %{}) do
    default = %{
      first_name: "#{Faker.Person.first_name()}_#{Faker.random_between(1, 10)}",
      last_name: "#{Faker.Person.last_name()}_#{Faker.random_between(1, 10)}",
      email: "user_email#{Faker.random_between(1, 5000)}@email.com"
    }

    Map.merge(default, params)
  end

  def insert!(attrs \\ %{}) do
    attrs
    |> build()
    |> @schema.create_changeset()
    |> @repo.insert!()
  end
end
