# frozen_string_literal: true

require "test_helper"

module LearningTexts
  class FinderTest < ActiveSupport::TestCase
    test "returns results applying default order and sorting" do
      learning_text1 = create(:learning_text, :translation, created_at: 1.day.ago)
      learning_text2 = create(:learning_text, :translation, created_at: 1.day.from_now)

      result = Finder.new.call

      assert_equal [learning_text2, learning_text1], result
    end

    test "returns ascending results" do
      learning_text1 = create(:learning_text, :translation, created_at: 1.day.ago)
      learning_text2 = create(:learning_text, :translation, created_at: 1.day.from_now)

      result = Finder.new(sort_direction: "asc").call

      assert_equal [learning_text1, learning_text2], result
    end

    test "returns sorted results" do
      learning_text1 = create(:learning_text, :translation, title: "cba")
      learning_text2 = create(:learning_text, :translation, title: "abc")

      result = Finder.new(sort_column: "title").call

      assert_equal [learning_text1, learning_text2], result
    end

    test "returns results matching search param" do
      learning_text = create(:learning_text, :translation, title: "title")
      create(:learning_text, title: "not matching")

      result = Finder.new(search: "itl").call

      assert_equal [learning_text], result
    end

    test "returns filtered results" do
      create(:learning_text, id: 1)
      learning_text = create(:learning_text, :translation, id: 2)

      result = Finder.new(id: 2).call

      assert_equal [learning_text], result
    end

    test "returns results filtered by base language" do
      en_language = Language.find_by(code: "en")
      pl_language = Language.find_by(code: "pl")
      de_language = Language.find_by(code: "de")

      base_learning_text = create(:learning_text, language: pl_language)
      learning_text = create(:learning_text, language: en_language, base_learning_text:)
      base_learning_text2 = create(:learning_text, language: en_language)
      create(:learning_text, :translation, language: de_language,
                                           base_learning_text: base_learning_text2)

      result = Finder.new(base_language: ["pl"]).call

      assert_equal [learning_text], result
    end

    test "returns results filtered by translation language" do
      en_language = Language.find_by(code: "en")
      pl_language = Language.find_by(code: "pl")
      de_language = Language.find_by(code: "de")

      base_learning_text = create(:learning_text, language: en_language)
      learning_text = create(:learning_text, language: pl_language, base_learning_text:)
      base_learning_text2 = create(:learning_text, language: en_language)
      create(:learning_text, :translation, language: de_language,
                                           base_learning_text: base_learning_text2)

      result = Finder.new(translation_language: ["pl"]).call

      assert_equal [learning_text], result
    end

    test "returns results filtered all filters at once" do
      en_language = Language.find_by(code: "en")
      pl_language = Language.find_by(code: "pl")
      de_language = Language.find_by(code: "de")

      base_learning_text = create(:learning_text, language: en_language)
      learning_text = create(:learning_text,
                             language: pl_language,
                             base_learning_text:,
                             title: "title")
      base_learning_text2 = create(:learning_text, language: en_language)
      create(:learning_text, :translation, language: de_language,
                                           base_learning_text: base_learning_text2)

      result = Finder.new(base_language: ["en"], translation_language: ["pl"], search: "itl").call

      assert_equal [learning_text], result
    end

    test "returns default scopre returns only translations" do
      create(:learning_text)
      learning_text = create(:learning_text, :translation)

      result = Finder.new.call

      assert_equal [learning_text], result
    end
  end
end
