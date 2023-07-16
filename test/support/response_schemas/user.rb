# frozen_string_literal: true

module ResponseSchemas
  class User < Dry::Schema::JSON
    define do
      required(:id).filled(:integer)
      required(:email).filled(:string)
    end
  end
end
