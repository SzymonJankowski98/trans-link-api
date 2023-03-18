# frozen_string_literal: true

class Resource < ApplicationRecord
  VISIBILITIES = [
    PUBLIC = "public",
    PRIVATE = "private"
  ].freeze

  belongs_to :user
end
