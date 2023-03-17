# frozen_string_literal: true

require "test_helper"

module Users
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "#create signs in as user" do
      User.create(create_user_params)

      post sign_in_v1_user_session_path(user: create_user_params)

      assert_response :created
    end

    test "#create returns unauthorized when wrong password" do
      User.create(create_user_params)
      params = create_user_params.merge({ password: "wrong password" })

      post sign_in_v1_user_session_path(user: params)

      assert_response :unauthorized
    end

    test "#destroy signs out user" do
      post sign_out_v1_user_session_path

      assert_response :no_content
    end

    private

    def create_user_params
      { email: "test@example.com", password: "12345678" }
    end
  end
end
