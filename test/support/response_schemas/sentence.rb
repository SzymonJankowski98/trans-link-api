# frozen_string_literal: true

module ResponseSchemas
  class Sentence < Dry::Schema::JSON
    define do
      required(:id).filled(:integer)
      required(:text).filled(:string)
      required(:order).filled(:integer)
    end
  end
end
