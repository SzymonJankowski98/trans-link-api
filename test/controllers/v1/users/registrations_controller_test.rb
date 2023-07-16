# frozen_string_literal: true

require "test_helper"

module V1
  module Users
    class RegistrationsControllerTest < ActionDispatch::IntegrationTest
      test "#create registers user" do
        assert_difference -> { User.count }, 1 do
          post v1_user_registration_path(user: create_user_params)
        end

        assert_response :created
        assert_predicate user_response_schema.call(response.parsed_body), :success?
      end

      test "#create returns errors when registration fails" do
        invalid_params = create_user_params.merge(password: "123")
        assert_no_difference -> { User.count } do
          post v1_user_registration_path(user: invalid_params)
        end

        assert_response :unprocessable_entity
        assert_predicate response.parsed_body["errors"], :present?
      end

      private

      def create_user_params
        { email: "test@example.com", password: "12345678" }
      end

      def user_response_schema
        Dry::Schema.Params do
          required(:user).filled(ResponseSchemas::User.new.type_schema)
        end
      end
    end
  end
end
