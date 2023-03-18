# frozen_string_literal: true

require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  test "#belongs_to user returns associated record" do
    resource = create(:resource)
    user = resource.user

    assert_equal user, resource.user
  end
end
