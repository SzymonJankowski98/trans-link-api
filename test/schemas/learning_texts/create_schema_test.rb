# frozen_string_literal: true

require "test_helper"

module LearningTexts
  class CreateSchemaTest < ActiveSupport::TestCase
    test "returns success when params are valid" do
      valid_params_set.each do |valid_params|
        result = CreateSchema.new.call(valid_params)

        assert_predicate result, :success?
      end
    end

    test "returns failure when params are invalid" do
      result = CreateSchema.new.call(invalid_params)

      assert_predicate result, :failure?
      assert_equal expected_error, result.errors.to_h # rubocop:disable Rails/DeprecatedActiveModelErrorsMethods
    end

    private

    def valid_params_set
      [
        {
          learning_text: {
            title: "title",
            translation_title: "translated title",
            level: "B1",
            visibility: "private",
            base_language: "pl",
            translation_language: "en",
            sentences: [
              { base: "Sentence 1", translation: "Translated sentence 1" },
              { base: "Sentence 2", translation: "Translated sentence 2" },
            ],
            extra_param: "extra param"
          }
        },
        {
          learning_text: {
            title: "title",
            translation_title: "translated title",
            level: "B1",
            visibility: "",
            sentences: [
              { base: "Sentence 1", translation: "Translated sentence 1" },
              { base: "Sentence 2", translation: "Translated sentence 2" }
            ]
          }
        }
      ]
    end

    def invalid_params
      {
        learning_text: {
          title: 1,
          translation_title: 2,
          sentences: [
            { translation: "Translated sentence 1" },
            { base: "Sentence 2" }
          ]
        }
      }
    end

    def expected_error
      {
        learning_text: {
          title: ["must be a string"], 
          translation_title: ["must be a string"], 
          sentences: { 
            0 => { base: ["is missing"] }, 
            1 => { translation: ["is missing"] } 
          } 
        }
      }
    end
  end
end
