# frozen_string_literal: true

# == Schema Information
#
# Table name: sentences
#
#  id               :bigint           not null, primary key
#  order            :integer          not null
#  text             :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  learning_text_id :bigint           not null
#
# Indexes
#
#  index_sentences_on_learning_text_id  (learning_text_id)
#
# Foreign Keys
#
#  fk_rails_...  (learning_text_id => learning_texts.id)
#
require "test_helper"

class SentenceTest < ActiveSupport::TestCase
  test "validates presence of attributes" do
    %i[order text].each do |attribute|
      sentence = build(:sentence, attribute => nil)
      blank_error = { error: :blank }

      assert_not sentence.valid?
      assert_equal blank_error, sentence.errors.details[attribute]&.first
    end
  end

  test "#belongs_to learning_text returns associated record" do
    learning_text = create(:learning_text)
    sentence = create(:sentence, learning_text:)

    assert_equal learning_text, sentence.learning_text
  end
end
