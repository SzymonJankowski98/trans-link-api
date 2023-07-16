# frozen_string_literal: true

require "test_helper"

module V1
  class SentenceSerializerTest < ActiveSupport::TestCase
    test "serializes attributes" do
      sentence = create(:sentence)
      serialization = SentenceSerializer.new(sentence).as_json

      assert_predicate ResponseSchemas::Sentence.new.call(serialization), :success?
    end
  end
end
