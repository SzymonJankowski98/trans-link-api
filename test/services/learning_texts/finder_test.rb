# frozen_string_literal: true

require "test_helper"

module LearningTexts
  class FinderTest < ActiveSupport::TestCase
    test "returns results applying default order and sorting" do
      learning_text1 = create(:learning_text, created_at: 1.day.ago)
      learning_text2 = create(:learning_text, created_at: 1.day.from_now)

      result = Finder.new.call

      assert_equal [learning_text2, learning_text1], result
    end

    test "returns ascending results" do
      learning_text1 = create(:learning_text, created_at: 1.day.ago)
      learning_text2 = create(:learning_text, created_at: 1.day.from_now)

      result = Finder.new(sort_direction: "asc").call

      assert_equal [learning_text1, learning_text2], result
    end

    test "returns sorted results" do
      learning_text1 = create(:learning_text, title: "cba")
      learning_text2 = create(:learning_text, title: "abc")

      result = Finder.new(sort_column: "title").call

      assert_equal [learning_text1, learning_text2], result
    end

    test "returns filtered results" do
      create(:learning_text, id: 1)
      learning_text = create(:learning_text, id: 2)

      result = Finder.new(id: 2).call

      assert_equal [learning_text], result
    end

    test "returns resultes applying provided scope" do
      create(:learning_text, id: 1)
      learning_text = create(:learning_text, id: 2)

      base_scope = LearningText.where(id: 2)
      result = Finder.new(base_scope:).call

      assert_equal [learning_text], result
    end
  end
end
