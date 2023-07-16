# frozen_string_literal: true

module LearningTexts
  class IndexSchema < Dry::Schema::Params
    define do
      optional(:id).array(:integer)
      optional(:base_language).array(:string)
      optional(:translation_language).array(:string)
      optional(:search).filled(:string)
      optional(:page).filled(:integer)
      optional(:per_page).filled(:integer)
      optional(:sort_column).filled(:string)
      optional(:sort_direction).filled(:string)
    end
  end
end
