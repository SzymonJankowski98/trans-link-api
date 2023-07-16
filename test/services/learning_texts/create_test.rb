# frozen_string_literal: true

require "test_helper"

module LearningTexts
  class CreateTest < ActiveSupport::TestCase
    test "creates learning text and translation successfully" do
      assert_difference -> { LearningText.count }, +2 do
        assert_difference -> { Sentence.count }, +4 do
          response = Create.new(action_params, author).call

          assert_predicate response, :success?

          learning_text = response.value!

          assert_equal "title", learning_text.title
          assert_equal "B1", learning_text.level
          assert_equal "private", learning_text.visibility
          assert_equal Language.find_by(code: "pl"), learning_text.language

          learning_text.sentences.each_with_index do |sentence, index|
            assert_equal "Sentence #{index + 1}", sentence.text
            assert_equal index, sentence.order
          end

          translation = learning_text.translations.first

          assert_equal "translated title", translation.title
          assert_equal "B1", translation.level
          assert_equal "private", translation.visibility
          assert_equal Language.find_by(code: "en"), translation.language

          translation.sentences.each_with_index do |sentence, index|
            assert_equal "Translated sentence #{index + 1}", sentence.text
            assert_equal index, sentence.order
          end
        end
      end
    end

    test "fails when base language is not supported" do
      response = Create.new({ base_language: "ab" }, author).call

      assert_predicate response, :failure?
      assert_equal "This base language is not supported", response.failure
    end

    test "fails when translation language is not supported" do
      response = Create.new({ base_language: "en",  translation_language: "ab" }, author).call

      assert_predicate response, :failure?
      assert_equal "This translation language is not supported", response.failure
    end

    test "fails when both languages are the same" do
      response = Create.new({ base_language: "en", translation_language: "en" }, author).call

      assert_predicate response, :failure?
      assert_equal "Base and translation languages have to be different", response.failure
    end

    test "fails when base learning text params are incorrect" do
      assert_no_difference -> { LearningText.count } do
        response = Create.new(action_params.merge(visibility: "none"), author).call

        assert_predicate response, :failure?
        assert_equal "Visibility is not included in the list", response.failure
      end
    end

    test "fails when translation learning text params are incorrect" do
      assert_no_difference -> { LearningText.count } do
        response = Create.new(action_params.merge(translation_title: nil), author).call

        assert_predicate response, :failure?
        assert_equal "Title can't be blank", response.failure
      end
    end

    test "fails when sentence params are incorrect" do
      sentences = {
        sentences: [
          { base: nil, translation: "Translated text" }
        ]
      }

      assert_no_difference -> { LearningText.count } do
        assert_no_difference -> { Sentence.count } do
          response = Create.new(action_params.merge(sentences), author).call

          assert_predicate response, :failure?
          assert_equal "Text can't be blank", response.failure
        end
      end
    end

    private

    def action_params
      {
        title: "title",
        translation_title: "translated title",
        level: "B1",
        visibility: "private",
        base_language: "pl",
        translation_language: "en",
        sentences: [
          { base: "Sentence 1", translation: "Translated sentence 1" },
          { base: "Sentence 2", translation: "Translated sentence 2" }
        ]
      }
    end

    def author
      @author ||= create(:user)
    end
  end
end
