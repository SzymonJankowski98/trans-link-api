# frozen_string_literal: true

require "test_helper"

module V1
  class LearningTextSerializerTest < ActiveSupport::TestCase
    test "serializes attributes" do
      learning_text = create(:learning_text)
      serialization = LearningTextSerializer.new(learning_text).as_json

      assert_predicate Schemas::LearningText::SCHEMA.call(serialization), :success?
    end
  end
end
