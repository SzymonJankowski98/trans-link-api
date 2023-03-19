# frozen_string_literal: true

require "test_helper"

module V1
  class UserSerializerTest < ActiveSupport::TestCase
    test "serializes attributes" do
      user = create(:user)
      serialization = UserSerializer.new(user).as_json

      assert_predicate Schemas::User::SCHEMA.call(serialization), :success?
    end
  end
end
