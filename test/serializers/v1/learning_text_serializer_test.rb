# frozen_string_literal: true

require "test_helper"

module V1
  class LearningTextSerializerTest < ActiveSupport::TestCase
    test "serializes attributes" do
      base_learning_text = create(:learning_text)
      learning_text = create(:learning_text, :with_access_key, base_learning_text:)
      create(:sentence, learning_text:)
      translation = create(:learning_text, :with_access_key, base_learning_text: learning_text)
      create(:sentence, learning_text: translation)

      serialization = LearningTextSerializer.new(learning_text).as_json

      assert_predicate ResponseSchemas::LearningText.new.call(serialization), :success?
    end
  end
end
