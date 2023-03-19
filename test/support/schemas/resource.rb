# frozen_string_literal: true

module Schemas
  module Resource
    SCHEMA = Dry::Schema.JSON do
      required(:id).filled(:integer)
      required(:user_id).filled(:integer)
      required(:type).filled(:string)
      required(:visibility).filled(:string)
    end
  end
end
