# frozen_string_literal: true

module Schemas
  module LearningText
    SCHEMA = Dry::Schema.JSON do
      required(:id).filled(:integer)
      required(:user_id).filled(:integer)
      required(:title).filled(:string)
      required(:created_at).filled(:date_time)
    end
  end
end
