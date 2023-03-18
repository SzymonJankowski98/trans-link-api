# frozen_string_literal: true

FactoryBot.define do
  factory :resource do
    user
    visibility { "public" }
    type { "" }
  end
end
