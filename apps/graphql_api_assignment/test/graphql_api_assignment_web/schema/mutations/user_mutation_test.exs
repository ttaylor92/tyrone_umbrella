defmodule GraphqlApiAssignmentWeb.Schema.Mutations.UserMutationTest do
  use SchemasPG.Support.Datacase

  import GraphqlApiAssignment.Support.HelperFunctions, only: [setup_mock_accounts: 1]

  alias SchemasPG.Support.Factory.AccountManagement.UserFactory
  alias GraphqlApiAssignmentWeb.Schema

  @valid_secret_key "Imsecret"

  @create_user_query """
  mutation($name: String!, $email: String!, $preferences: PreferenceInput!) {
    createUser(name: $name, email: $email, preferences: $preferences) {
      id
      name
      email
      preferences {
        likesEmails
        likesPhoneCalls
        likesFaxes
        userId
      }
    }
  }
  """
  @update_user_preferences_query """
  mutation($userId: Int!, $likesEmails: Boolean, $likesFaxes: Boolean, $likesPhoneCalls: Boolean) {
    updateUserPreferences(userId: $userId, likesEmails: $likesEmails, likesFaxes: $likesFaxes, likesPhoneCalls: $likesPhoneCalls) {
      likesEmails
      likesFaxes
      likesPhoneCalls
      userId
    }
  }
  """
  @update_user_query """
  mutation($id: Int!, $name: String, $email: String) {
    updateUser(id: $id, name: $name, email: $email) {
      id
      name
      email
      preferences {
        likesEmails
        likesPhoneCalls
        likesFaxes
        userId
      }
    }
  }
  """

  describe "@createUser" do
    test "creates a user successfully" do
      variables = %{
        "name" => "John Doe",
        "email" => "john@example.com",
        "preferences" => %{
          "likesEmails" => true,
          "likesFaxes" => false,
          "likesPhoneCalls" => true
        }
      }

      assert {:ok, %{data: %{"createUser" => user}}} =
               Absinthe.run(@create_user_query, Schema, variables: variables)

      assert user["name"] === "John Doe"
      assert user["email"] === "john@example.com"
      assert user["preferences"]["likesEmails"] === true
      assert user["preferences"]["likesFaxes"] === false
      assert user["preferences"]["likesPhoneCalls"] === true
    end

    test "does not create a user with invalid email format" do
      variables = %{
        "name" => "John Doe",
        "email" => "invalid_email",
        "preferences" => %{
          "likesEmails" => true,
          "likesFaxes" => false,
          "likesPhoneCalls" => true
        }
      }

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@create_user_query, Schema, variables: variables)
      error = List.first(errors)
      assert error.message === "Email has invalid format"
      assert error.code === :bad_request
    end
  end

  describe "@updateUser" do
    setup [:setup_mock_accounts]

    test "updates a user successfully", context do

      variables = %{"id" => context.user.id, "name" => "Jane Doe", "email" => "jane@example.com"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUser" => updated_user}}} =
               Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)

      assert updated_user["name"] === variables["name"]
      assert updated_user["email"] === variables["email"]
    end


    test "updates a user's name successfully", context do
      variables = %{"id" => context.user.id, "name" => "Updated Name"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUser" => updated_user}}} =
               Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)

      assert updated_user["name"] === variables["name"]
      assert updated_user["email"] === context.user.email
    end

    test "updates a user's email successfully", context do
      variables = %{"id" => context.user.id, "email" => "updated_email@example.com"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUser" => updated_user}}} =
               Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)

      assert updated_user["email"] === variables["email"]
      assert updated_user["name"] === context.user.name
    end

    test "cannot update a user with non-existent ID" do
      user_id = 999
      message = "Unsupported request"
      variables = %{"id" => user_id, "name" => "Jane Doe", "email" => "jane@example.com"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)

      assert List.first(errors).message === message
    end

    # MIDDLEWARE CHECKS
    test "denies access to update with incorrect secret key", context do
      variables = %{"id" => context.user.id, "name" => "Jane Doe", "email" => "jane@example.com"}
      context_map = %{secret_key: "random_key"}

      assert {:ok, %{errors: [%{
        code: :unauthorized,
         message: "You are not allowed to access this resource."
      }]}} =
               Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)
    end

    test "cannot update user to an existing email", context do
      _another_user = UserFactory.insert!(%{email: "test@mail.com"})
      variables = %{"id" => context.user.id, "name" => "Jane Doe", "email" => "test@mail.com"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{errors: [%{
        code: :conflict,
         message: "Email Already Exists"
      }]}} =
               Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)
    end

    test "cannot update user to an invalid email", context do
      variables = %{"id" => context.user.id, "name" => "Jane Doe", "email" => "idkman"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{errors: [%{
        code: :bad_request,
         message: "Email has invalid format"
      }]}} = Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)
    end

    test "cannot update user to an invalid name", context do
      variables = %{"id" => context.user.id, "name" => "J", "email" => "idkman@mail.com"}
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{errors: [%{
        code: :bad_request,
         message: "Unsupported request",
         details: %{name: ["should be at least 3 character(s)"]}
      }]}} = Absinthe.run(@update_user_query, Schema, variables: variables, context: context_map)
    end
  end

  describe "@updateUserPreferences" do
    setup [:setup_mock_accounts]

    test "updates all user preferences successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesEmails" => true,
        "likesFaxes" => true,
        "likesPhoneCalls" => true
      }
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables, context: context_map)

      assert preferences["likesEmails"] === true
      assert preferences["likesFaxes"] === true
      assert preferences["likesPhoneCalls"] === true
    end

    test "updates user preference for likesEmails successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesEmails" => true
      }
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables, context: context_map)

      assert preferences["likesEmails"] === true
    end

    test "updates user preference for likesFaxes successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesFaxes" => true
      }
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables, context: context_map)

      assert preferences["likesFaxes"] === true
    end

    test "updates user preference for likesPhoneCalls successfully", context do
      variables = %{
        "userId" => context.user.id,
        "likesPhoneCalls" => true
      }
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{data: %{"updateUserPreferences" => preferences}}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables, context: context_map)

      assert preferences["likesPhoneCalls"] === true
    end

    test "updates user preferences with non-existent user ID" do
      variables = %{
        "userId" => 99_999,
        "likesEmails" => false,
        "likesFaxes" => true,
        "likesPhoneCalls" => false
      }
      context_map = %{secret_key: @valid_secret_key}

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_preferences_query, Schema, variables: variables, context: context_map)
      assert List.first(errors).message ===  "Unexpected error occurred"
    end

    test "denies access to update with incorrect secret key", context do
      variables = %{
        "userId" => context.user.id,
        "likesEmails" => true,
        "likesFaxes" => true,
        "likesPhoneCalls" => true
      }
      context_map = %{secret_key: "random_key"}

      assert {:ok, %{errors: [%{
        code: :unauthorized,
         message: "You are not allowed to access this resource."
      }]}} = Absinthe.run(@update_user_preferences_query, Schema, variables: variables, context: context_map)
    end
  end
end
