# frozen_string_literal: true

# == Schema Information
#
# Table name: resources
#
#  id         :bigint           not null, primary key
#  type       :string
#  visibility :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_resources_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class ResourceTest < ActiveSupport::TestCase
  test "#belongs_to user returns associated record" do
    resource = create(:resource)
    user = resource.user

    assert_equal user, resource.user
  end
end
