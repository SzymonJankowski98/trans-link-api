# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class LanguageTest < ActiveSupport::TestCase
  test "validates presence of attributes" do
    %i[name code].each do |attribute|
      learning_text = build(:language, attribute => nil)
      blank_error = { error: :blank }

      assert_not learning_text.valid?
      assert_equal blank_error, learning_text.errors.details[attribute]&.first
    end
  end
end
