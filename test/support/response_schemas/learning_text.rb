# frozen_string_literal: true

module ResponseSchemas
  class LearningText < Dry::Schema::JSON
    define do
      required(:id).filled(:integer)
      required(:access_key).filled(:string)
      required(:access_key_enabled).filled(:bool)
      required(:level).filled(:string)
      required(:title).filled(:string)
      required(:visibility).filled(:string)
      required(:language_id).filled(:integer)
      required(:user_id).filled(:integer)
      required(:base_learning_text_id).filled(:integer)
      required(:created_at).filled(:date_time)

      optional(:translations).array(:hash).schema do
        ResponseSchemas::LearningText
      end
    end
  end
end
