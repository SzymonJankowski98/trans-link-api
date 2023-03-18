# frozen_string_literal: true

module Schemas
  module User
    SCHEMA = Dry::Schema.JSON do
      required(:id).filled(:integer)
      required(:email).filled(:string)
    end
  end
end
