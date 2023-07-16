# frozen_string_literal: true

module V1
  class SentenceSerializer < ActiveModel::Serializer
    attribute :id
    attribute :order
    attribute :text
  end
end
