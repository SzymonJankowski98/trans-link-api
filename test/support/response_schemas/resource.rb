# frozen_string_literal: true

module ResponseSchemas
  class Resource < Dry::Schema::JSON
    define do
      required(:id).filled(:integer)
      required(:user_id).filled(:integer)
      required(:type).filled(:string)
      required(:visibility).filled(:string)
    end
  end
end
