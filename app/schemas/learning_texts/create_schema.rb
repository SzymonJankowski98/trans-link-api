# frozen_string_literal: true

module LearningTexts
  class CreateSchema < Dry::Schema::Params
    define do
      required(:learning_text).hash do
        required(:title).filled(:string)
        required(:translation_title).filled(:string)
        optional(:level).filled(:string)
        optional(:visibility).maybe(:string)
        optional(:base_language).filled(:string)
        optional(:translation_language).filled(:string)
        required(:sentences).array(:hash) do
          required(:base).filled(:string)
          required(:translation).filled(:string)
        end
      end
    end
  end
end