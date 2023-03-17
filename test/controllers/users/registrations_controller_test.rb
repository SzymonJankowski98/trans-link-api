# frozen_string_literal: true

require "test_helper"

module Users
  class RegistrationsControllerTest < ActionDispatch::IntegrationTest
    test "#create registers user" do
      assert_difference -> { User.count }, 1 do
        post v1_user_registration_path(user: create_user_params)
      end

      assert_response :created
    end

    private

    def create_user_params
      { email: "test@example.com", password: "12345678" }
    end
  end
end
