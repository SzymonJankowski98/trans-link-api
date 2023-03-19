# frozen_string_literal: true

require "test_helper"
module V1
  module Users
    class SessionsControllerTest < ActionDispatch::IntegrationTest
      test "#create signs in as user" do
        User.create(create_user_params)

        post sign_in_v1_user_session_path(user: create_user_params)

        assert_response :created
        assert_predicate user_response_schema.call(response.parsed_body), :success?
      end

      test "#create returns unauthorized when wrong password" do
        User.create(create_user_params)
        params = create_user_params.merge({ password: "wrong password" })

        post sign_in_v1_user_session_path(user: params)

        assert_response :unauthorized
        assert_equal unauthorized_error, response.parsed_body
      end

      test "#create returns unauthorized when user doesn't exist" do
        User.create(create_user_params)
        params = create_user_params.merge({ email: "wrong email" })

        post sign_in_v1_user_session_path(user: params)

        assert_response :unauthorized
        assert_equal unauthorized_error, response.parsed_body
      end

      test "#destroy signs out user" do
        user = User.create(create_user_params)
        headers = { "Accept" => "application/json", "Content-Type" => "application/json" }
        auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

        post sign_out_v1_user_session_path, headers: auth_headers

        assert_response :no_content
      end

      private

      def create_user_params
        { email: "test@example.com", password: "12345678" }
      end

      def unauthorized_error
        { "errors" => { "base" => ["Invalid email or password."] } }
      end

      def user_response_schema
        Dry::Schema.Params do
          required(:user).filled(Schemas::User::SCHEMA)
        end
      end
    end
  end
end
