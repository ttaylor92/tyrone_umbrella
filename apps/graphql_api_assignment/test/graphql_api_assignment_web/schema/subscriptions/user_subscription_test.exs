defmodule GraphqlApiAssignmentWeb.Schema.Subscriptions.UserSubscriptionTest do
  use SchemasPG.Support.Datacase
  use GraphqlApiAssignmentWeb.Support.SubscriptionCase

  import GraphqlApiAssignment.Support.HelperFunctions, only: [setup_mock_accounts: 1]

  @user_creation_subscription """
  subscription createdUser {
    createdUser {
      id
      firstName
      lastName
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

  @updated_user_preferences_subscription """
  subscription updatedUserPreferences($userId: Int!) {
    updatedUserPreferences(userId: $userId) {
      likesEmails
      likesFaxes
      likesPhoneCalls
      userId
    }
  }
  """

  @user_auth_token_subscription """
  subscription userAuthToken($userId: String!) {
    userAuthToken(userId: $userId)
  }
  """

  describe "@user" do
    setup [:setup_mock_accounts, :setup_socket]

    @create_user_query """
    mutation($firstName: String!, $lastName: String!, $email: String!, $preferences: PreferenceInput!) {
      createUser(firstName: $firstName, lastName: $lastName, email: $email, preferences: $preferences) {
        id
        firstName
        lastName
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
    test "created_user subscriptions is triggered on user creation", %{socket: socket} do
      # Setup a socket and join the channel
      ref = push_doc(socket, @user_creation_subscription)
      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @create_user_query,
          variables: %{
            "firstName" => "John",
            "lastName" => "Doe",
            "email" => "john@example.com",
            "preferences" => %{
              "likesEmails" => true,
              "likesFaxes" => false,
              "likesPhoneCalls" => true
            }
          }
        )

      assert_reply ref, :ok, _reply

      assert_push "subscription:data", data

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "createdUser" => %{
                     "email" => "john@example.com",
                     "preferences" => %{
                       "likesEmails" => true,
                       "likesFaxes" => false,
                       "likesPhoneCalls" => true
                     }
                   }
                 }
               }
             } = data
    end

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
    test "updated_user_preferences subscriptions is triggered on preference update", %{
      socket: socket,
      user: user
    } do
      # Setup a socket and join the channel
      ref =
        push_doc(socket, @updated_user_preferences_subscription,
          variables: %{
            "userId" => user.id
          }
        )

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      ref =
        push_doc(socket, @update_user_preferences_query,
          variables: %{
            "userId" => user.id,
            "likesEmails" => true,
            "likesFaxes" => true,
            "likesPhoneCalls" => true
          }
        )

      assert_reply ref, :ok, _reply

      assert_push "subscription:data", data

      user_id = user.id

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "updatedUserPreferences" => %{
                     "likesEmails" => true,
                     "likesFaxes" => true,
                     "likesPhoneCalls" => true,
                     "userId" => ^user_id
                   }
                 }
               }
             } = data
    end

    test "user_auth_token subscriptions is triggered on token generation", %{
      socket: socket,
      user: user
    } do
      # Setup a socket and join the channel
      ref =
        push_doc(socket, @user_auth_token_subscription,
          variables: %{
            "userId" => "#{user.id}"
          }
        )

      assert_reply ref, :ok, %{subscriptionId: subscription_id}

      assert {:ok, _pid} =
               GraphqlApiAssignment.TokenCache.start_link(name: :cache)

      assert {:ok, _pid} =
               GraphqlApiAssignment.SecurityClearanceQueue.start_link(name: :sec_queue)

      assert {:ok, _pid} =
               GraphqlApiAssignment.ResourceScheduler.start_link(
                 name: :res_schedule,
                 interval: :timer.seconds(1)
               )

      assert {:ok, _pid} =
               GraphqlApiAssignment.TokenPipelineSupervisor.start_link(
                 name: :token_test,
                 prefix: :test
               )

      assert_push "subscription:data", data, :timer.seconds(5)

      assert %{
               subscriptionId: ^subscription_id,
               result: %{
                 data: %{
                   "userAuthToken" => token
                 }
               }
             } = data

      assert is_binary(token)
    end
  end

  defp setup_socket(context) do
    {:ok, socket} =
      Phoenix.ChannelTest.connect(GraphqlApiAssignmentWeb.UserSocket, %{})

    {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

    Map.put(context, :socket, socket)
  end
end
