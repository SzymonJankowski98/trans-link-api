# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#has_many resources returns accociated records" do
    user = create(:user)
    resources = create_list(:resource, 2, user:)

    assert_equal resources, user.resources
  end
end
