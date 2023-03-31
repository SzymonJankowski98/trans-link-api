# frozen_string_literal: true

# == Schema Information
#
# Table name: learning_texts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_learning_texts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class LearningTextTest < ActiveSupport::TestCase
  test "#belongs_to user as author returns associated record" do
    author = create(:user)
    learning_text = create(:learning_text, author:)

    assert_equal author, learning_text.author
  end

  test "validates presence of attributes" do
    %i[title].each do |attribute|
      learning_text = build(:learning_text, attribute => nil)
      blank_error = { error: :blank }

      assert_not learning_text.valid?
      assert_equal blank_error, learning_text.errors.details[attribute]&.first
    end
  end
end